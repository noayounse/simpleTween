class CSTween extends STween {
  color startColor, endColor;
  private color valueC;

  // redirect vars
  color redirectNewTargetC;
  color redirectOldTargetC;

  CSTween (int duration_, int delay_, color startColor_, color endColor_) {
    super(duration_, delay_);
    startColor = startColor_;
    endColor = endColor_;
    valueC = startColor;
  } // end constructor

    void playLive(color valueIn) {
    if (valueIn - endColor != 0 || (!super.isPlaying() && startColor != endColor)) {
      if (super.isPlaying() && !super.inRedirect) {
        redirect(valueIn);
      }
      else if (!super.isPlaying() && !super.inRedirect) {
        setBegin(valueC);
        setEnd(valueIn);
        super.play();
      }
      else return;
    }
  } // end playLive


  void setBegin(color valueIn) {
    startColor = valueIn;
  } // end setBegin

    void setEnd (color valueIn) {
    setBegin(valueC);
    super.setBegin(0);
    endColor = valueIn;
  } // end setEnd

  color getBegin() {
    return startColor;
  } // end getBegin

  color getEnd () {
    return endColor;
  } // end getEnd

  color value() {
    updateRedirectC();
    float multiplier = super.valueST();
    if (multiplier == 1) valueC = endColor;
    else if (multiplier == 0) valueC = startColor;
    else {
      float r = (multiplier * red(endColor) + (1 - multiplier) * red(startColor));
      float g = (multiplier * green(endColor) + (1 - multiplier) * green(startColor));
      float b = (multiplier * blue(endColor) + (1 - multiplier) * blue(startColor));
      float a = (multiplier * alpha(endColor) + (1 - multiplier) * alpha(startColor));
      valueC = color(r, g, b, a);
    }
    // look for and assign any nextTargets
    if (!super.isPlaying() && super.isDone() && super.nextTargets.size() > 0) {
      NextTarget nextTarget = super.nextTargets.get(0);
      super.nextTargets.remove(0);
      super.setDuration(nextTarget.getDuration());
      super.setDelay(nextTarget.getDelay());
      setEnd((Integer)nextTarget.getTarget());
      super.play();
    }     
    return valueC;
  } // end value

  void redirect(color c) {
    if (super.isPlaying && super.redirectTween == null) {
      super.redirect();
      redirectNewTargetC = c;
      redirectOldTargetC = endColor;
    }
  } // end redirect  

  void updateRedirectC() {
    if (super.inRedirect) {
      if (super.redirectTween.isDone()) {
        endColor = redirectNewTargetC;
      }
      else {
        float r = (super.redirectTween.valueST() * red(redirectNewTargetC) + (1 - super.redirectTween.valueST()) * red(redirectOldTargetC));
        float g = (super.redirectTween.valueST() * green(redirectNewTargetC) + (1 - super.redirectTween.valueST()) * green(redirectOldTargetC));
        float b = (super.redirectTween.valueST() * blue(redirectNewTargetC) + (1 - super.redirectTween.valueST()) * blue(redirectOldTargetC));
        float a = (super.redirectTween.valueST() * alpha(redirectNewTargetC) + (1 - super.redirectTween.valueST()) * alpha(redirectOldTargetC));        
        endColor = color(r, g, b, a);
      }
    }
  } // end updateRedirect
} // end class CSTween

