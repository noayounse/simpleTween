class FSTween extends STween {
  float startFloat = 0f;
  float endFloat = 1f;

  private color valueF;

  // redirect vars
  color redirectNewTargeF;
  color redirectOldTargetF;

  FSTween (float duration_, float delay_, float startFloat_, float endFloat_){
    super(duration_, delay_, 0f, 1f);
    startFloat = startFloat_;
    endFloat = endFloat_;
    valueF = startFloat;
  } // end constructor

    void playLive(color valueIn) {
    if (valueIn - endFloat != 0) {
      if (super.isPlaying()) {
        redirect(valueIn);
      }
      else {
        setBegin(valueF);
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

  color value() {
    updateRedirectC();
    float multiplier = super.valueST();
    if (multiplier == 1) valueF = endFloat;
    else if (multiplier == 0) valueF = startFloat;
    else {
      valueF = (multiplier * endFloat) + (1 - multiplier) * startFloat);
    }
    return valueF;
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

