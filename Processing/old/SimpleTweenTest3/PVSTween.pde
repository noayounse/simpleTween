class PVSTween extends STween {
  PVector startPV = new PVector();
  PVector endPV = new PVector();
  private PVector valuePV = new PVector();

  // redirect vars
  PVector redirectNewTargetPV = new PVector();
  PVector redirectOldTargetPV = new PVector();

  PVSTween (int duration_, int delay_, PVector startPV_, PVector endPV_) {
    super(duration_, delay_);
    startPV = startPV_;
    endPV = endPV_;
    valuePV = startPV.get();
  } // end constructor

  void playLive(PVector valueIn) {
    PVector test = PVector.sub(valueIn, endPV);
    if ((valueIn.x - endPV.x != 0 || valueIn.y - endPV.y != 0 || valueIn.z - endPV.z != 0)  || (!super.isPlaying() && ((startPV.x != endPV.x && startPV.y != endPV.y && startPV.z != endPV.z)))) {
      if (super.isPlaying() && !super.inRedirect) {
        redirect(valueIn);
      }
      else if (!super.isPlaying() && !super.inRedirect) {
        setBegin(valuePV);
        setEnd(valueIn);
        super.play();
      }
      else return;
    }
  } // end playLive

  void setBegin(PVector valueIn) {
    startPV = valueIn;
  } // end setBegin

    void setEnd (PVector valueIn) {
    setBegin(valuePV);
    super.setBegin(0);
    endPV = valueIn;
  } // end setEnd

  PVector getBegin() {
    return startPV;
  } // end getBegin

  PVector getEnd () {
    return endPV;
  } // end getEnd

  PVector value() {
    updateRedirectPV();
    float multiplier = super.valueST();
    //println("multiplier: " + multiplier);
    if (multiplier == 1) valuePV = endPV.get();
    else if (multiplier == 0) valuePV = startPV.get();
    else {
      PVector diff = PVector.sub(endPV, startPV);
      diff.mult(multiplier);
      valuePV = PVector.add(startPV, diff);
    }
    // look for and assign any nextTargets
    if (!super.isPlaying() && super.isDone() && super.nextTargets.size() > 0) {
      NextTarget nextTarget = super.nextTargets.get(0);
      super.nextTargets.remove(0);
      super.setDuration(nextTarget.getDuration());
      super.setDelay(nextTarget.getDelay());
      setEnd((PVector)nextTarget.getTarget());
      super.play();
    }     
    return valuePV;
  } // end value

  void redirect(PVector valueIn) {
    if (super.isPlaying && super.redirectTween == null) {
      super.redirect();
      redirectNewTargetPV = valueIn.get();
      redirectOldTargetPV = endPV.get();
    }
  } // end redirect  


    // note to self... ideally maybe the start position should shift too...?
  void updateRedirectPV() {
    if (super.inRedirect) {
      if (super.redirectTween.isDone()) {
        endPV = redirectNewTargetPV.get();
      }
      else {
        PVector a = PVector.mult(redirectNewTargetPV, (super.redirectTween.valueST()));
        PVector b = PVector.mult(redirectOldTargetPV, (1 - super.redirectTween.valueST()));
        endPV = PVector.add(b, a);
      }
    }
  } // end updateRedirect
} // end class PVSTween

