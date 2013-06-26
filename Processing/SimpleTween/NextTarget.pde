class NextTarget {
  private float[] nextTarget;
  private float duration = 1;
  private float delay = 0;
  private int timeMode = 0;
  NextTarget (float duration_, float delay_, float[] nextTarget_, int timeMode_) {
    nextTarget = nextTarget_;
    duration = duration_;
    delay = delay_;
    timeMode = timeMode_;
  } // end constructor
  float[] getTarget() {
    return nextTarget;
  } // end getTarget
  float getDuration() {
    return duration;
  }// end getDuration
  float getDelay() {
    return delay;
  } // end getDelay
} // end NextTarget

