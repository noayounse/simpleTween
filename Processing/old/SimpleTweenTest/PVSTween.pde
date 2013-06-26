class PVSTween extends STween {
  PVector startValue = new PVector();
  PVector endValue = new PVector();
  private PVector value = new PVector();
  float duration = 0f;
  float delay = 0f;
  STween st;

  final int LINEAR = 0;
  final int CUBIC_BOTH = 1;
  final int QUARTIC_BOTH = 2;
  int mode = CUBIC_BOTH;   

  PVSTween (float duration_, float delay_, PVector startValue_, PVector endValue_) {
    startValue = startValue_;
    endValue = endValue_;
    value = startValue.get();
    super.duration = duration_;
    super.delay = delay_;
    STween(duration, delay, 0f, 1f);
  } // end constructor

  void setModeLinear () {
    st.mode = LINEAR;
  } // end setModeLinear
  void setModeCubicBoth() {
    st.mode = CUBIC_BOTH;
  } // end setModeCubic
  void setModeQuarticBoth() {
    st.mode = QUARTIC_BOTH;
  } // end setModeQuarticBoth

  void play() {
    st.play();
  } // end play

    void pause() {
    st.pause();
  } // end pause

    boolean isPlaying() {
    return st.isPlaying();
  } // end isPlaying

    void setBegin(PVector valueIn) {
    startValue = valueIn;
  } // end setBegin

    void setEnd (PVector valueIn) {
    setBegin(value);
    st.setBegin(0);
    endValue = valueIn;
  } // end setEnd

  float getProgress () {
    return st.getProgress();
  } // end getProgress

    boolean isDone () {
    return st.isDone();
  } // end isDone


    PVector value() {
    float multiplier = st.value();
    //println("multiplier: " + multiplier);
    PVector diff = PVector.sub(endValue, startValue);
    diff.mult(multiplier);
    value = PVector.add(startValue, diff);
    return value;
  } // end value

    String toString () {
    return st.toString();
  } // end toString
} // end class PVTween

