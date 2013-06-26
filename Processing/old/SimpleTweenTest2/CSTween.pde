class CSTween extends STween {
  color startColor, endColor;
  private color valueC;

  // redirect vars
  color redirectNewTargetC;
  color redirectOldTargetC;

  CSTween (float duration_, float delay_, color startColor_, color endColor_) {
    super(duration_, delay_, 0f, 1f);
    startColor = startColor_;
    endColor = endColor_;
    valueC = startColor;
  } // end constructor

    void playLive(color valueIn) {
    if (valueIn - endColor != 0) {
      if (super.isPlaying()) {
        redirect(valueIn);
      }
      else {
        setBegin(valueC);
        setEnd(valueIn);
        super.play();
      }
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

  color valueColor() {
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
    return valueC;
  } // end value

  void redirect(color c) {
    if (super.isPlaying && super.redirectTween == null) {
      super.redirect(1);
      redirectNewTargetC = c;
      redirectOldTargetC = endColor;
    }
  } // end redirect  

  void updateRedirectC() {
    if (super.inRedirect) {
      if (super.redirectTween.isDone()) {
        endColor = redirectNewTargetC;
        super.inRedirect = false;
        super.redirectTween = null;
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
} // end class PVTween

