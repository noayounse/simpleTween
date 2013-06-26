class NextTarget {
  private Object nextTarget;
  private int duration = 1;
  private int delay = 0;
  NextTarget (Object nextTarget_, int duration_, int delay_) {
    nextTarget = nextTarget_;
    duration = duration_;
    delay = delay_;
  } // end constructor
  Object getTarget() {
    return nextTarget;
  } // end getTarget
  int getDuration() {
    return duration;
  }// end getDuration
  int getDelay() {
    return delay;
  } // end getDelay
} // end NextTarget

