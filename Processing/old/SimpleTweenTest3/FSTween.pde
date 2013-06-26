class FSTween extends STween {
  float startFloat = 0f;
  float endFloat = 1f;

  private float valueF;

  // redirect vars
  float redirectNewTargetF;
  float redirectOldTargetF;

  FSTween (int duration_, int delay_, float startFloat_, float endFloat_) {
    super(duration_, delay_);
    startFloat = startFloat_;
    endFloat = endFloat_;
    valueF = startFloat;
  } // end constructor

  void playLive(float valueIn) {
    if (valueIn - endFloat != 0 || (!super.isPlaying() && startFloat != endFloat)) {
      if (super.isPlaying() && super.redirectTween == null) {
        redirect(valueIn);
        println("making new redirect.  trying to go from old end: " + endFloat + " to new end: " + valueIn);
      }
      else if (!super.isPlaying() && !super.inRedirect) {
        setBegin(valueF);
        setEnd(valueIn);
        super.play();
      }
      else return;
    }
  } // end playLive


  void setBegin(float valueIn) {
    startFloat = valueIn;
  } // end setBegin

    void setEnd (float valueIn) {
    setBegin(valueF);
    super.setBegin(0);
    endFloat = valueIn;
  } // end setEnd

  float getBegin() {
    return startFloat;
  } // end getBegin

  float getEnd () {
    return endFloat;
  } // end getEnd

  float value() {
    updateRedirectC();
    float multiplier = super.valueST();
    if (multiplier == 1) valueF = endFloat;
    else if (multiplier == 0) valueF = startFloat;
    else {
      valueF = (multiplier * endFloat) + (1 - multiplier) * startFloat;
    }
    // look for and assign any nextTargets
    if (!super.isPlaying() && super.isDone() && super.nextTargets.size() > 0) {
      NextTarget nextTarget = super.nextTargets.get(0);
      super.nextTargets.remove(0);
      super.setDuration(nextTarget.getDuration());
      super.setDelay(nextTarget.getDelay());
      setEnd((Float)nextTarget.getTarget());
      super.play();
    } 
    return valueF;
  } // end value

  void redirect(float f) {
    if (super.isPlaying && super.redirectTween == null) {
      super.redirect();
      redirectNewTargetF = f;
      redirectOldTargetF = endFloat;
    }
  } // end redirect  

    void updateRedirectC() {
    if (super.inRedirect) {
      if (super.redirectTween.isDone()) {
        endFloat = redirectNewTargetF;
      }
      else {        
        endFloat = (super.redirectTween.valueST() * redirectNewTargetF) + (1 - super.redirectTween.valueST()) * redirectOldTargetF;
      }
    }
  } // end updateRedirect
} // end class FTween

