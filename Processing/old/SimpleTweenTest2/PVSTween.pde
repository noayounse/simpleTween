class PVSTween extends STween {
  PVector startPV = new PVector();
  PVector endPV = new PVector();
  private PVector valuePV = new PVector();

  // redirect vars
  PVector redirectNewTargetPV = new PVector();
  PVector redirectOldTargetPV = new PVector();

  PVSTween (float duration_, float delay_, PVector startPV_, PVector endPV_) {
    super(duration_, delay_, 0f, 1f);
    startPV = startPV_;
    endPV = endPV_;
    valuePV = startPV.get();
  } // end constructor

  void playLive(PVector valueIn) {
    PVector test = PVector.sub(valueIn, endPV);
    if (test.x + test.y + test.z != 0) {
      if (super.isPlaying()) {
        redirect(valueIn);
      }
      else {
        setBegin(valuePV);
        setEnd(valueIn);
        super.play();
      }
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

  PVector valuePVector() {
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
    return valuePV;
  } // end value

  void redirect(PVector valueIn) {
    if (super.isPlaying && super.redirectTween == null) {
      super.redirect(1);
      redirectNewTargetPV = valueIn.get();
      redirectOldTargetPV = endPV.get();
    }
  } // end redirect  

    void updateRedirectPV() {
    if (super.inRedirect) {
      if (super.redirectTween.isDone()) {
        endPV = redirectNewTargetPV.get();
        super.inRedirect = false;
        super.redirectTween = null;
      }
      else {
        PVector a = PVector.mult(redirectNewTargetPV, (super.redirectTween.valueST()));
        PVector b = PVector.mult(redirectOldTargetPV, (1 - super.redirectTween.valueST()));
        endPV = PVector.add(b, a);
      }
    }
  } // end updateRedirect
} // end class PVTween

