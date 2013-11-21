// Boolean SimpleTween
class BSTween extends STween {
  private boolean valueB = false;

  final int FRAMES_MODE = 1;
  final int SECONDS_MODE = 2;

  BSTween (float duration_) {
    super(duration_, 0, 0, 1);
    //super.setModeLinear();
    super.setEaseLinear();
  } // end constructor

    void playLive(float newDuration) {
    super.reset();
    super.setDuration(newDuration);
    play();
  } // end playLive

  void play() {
    super.play();
  } 

/*
  void setTimeToFrames() {
    setTimeMode(FRAMES_MODE);
  } // end setTimeToFrames
  void setTimeToSeconds() {
    setTimeMode(SECONDS_MODE);
  } // end setTimeToSeconds
  void setTimeMode(int modeIn) {
    super.setTimeMode(modeIn);
  } // end setTimeMode
  int getTimeMode() {
    return super.getTimeMode();
  } // end getTimeMode  
  */

    // fire will look at the value() and when it is true will toggle a fire and automatically reset the tween
  boolean fire() {
    boolean fire = false;
    if (value() == 1) {
      fire = true;
      super.reset();
    } 
    else fire = false; 
    return fire;
  } // end fire

    // value will return the value of valueB.  unlike fire(), it will not reset it
  boolean state() {
    float multiplier = super.value();
    if (multiplier == 1) {
      valueB = true;
    }
    else valueB = false;
    return valueB;
  } // end value
} // end class BSTween

