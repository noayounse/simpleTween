class BSTween extends STween {
  private boolean valueB = false;

  BSTween (int duration_) {
    super(duration_, 0);
    super.setModeLinear();
  } // end constructor

    void playLive(int newDuration) {
    super.resetProgress();
    super.setDuration(newDuration);
    play();
  } // end playLive

  void play() {
    super.play();
  } 

  // fire will look at the value() and when it is true will toggle a fire and automatically reset the tween
  boolean fire() {
    boolean fire = false;
    if (value()) {
      fire = true;
      super.resetProgress();
      super.pause();
    } 
    else fire = false; 
    return fire;
  } // end fire

    // value will return the value of valueB.  unlike fire(), it will not reset it
  boolean value() {
    float multiplier = super.valueST();
    if (multiplier == 1) {
      valueB = true;
    }
    else valueB = false;
    return valueB;
  } // end value
} // end class BSTween

