// Method SimpleTween
class MSTween {
  STweenManager st;
  String methodName;
  Object targetObj;

  MSTween (float durationDelay_, String methodName_, Object targetObj_) {
    st = new STweenManager(1);
    methodName = methodName_;
    targetObj = targetObj_;
    float[] start = {
      0
    };
    float[] end = {
      1
    };
    st.setInitialTweens(durationDelay_, 0, start, end);
  } // end constructor

  void setTimeToFrames() {
    st.setTimeToFrames();
  } // end setTimeToFrames
  void setTimeToSeconds() {
    st.setTimeToSeconds();
  } // end setTimeToSeconds
  int getTimeMode() {
    return st.getTimeMode();
  } // end getTimeMode

    void play() {
    if (!st.isPlaying()) st.onEnd(targetObj, methodName);
    st.play();
  } // end play
  
  public void stop() {
    if (st.isPlaying()) {
      println("trying to stop mst");
      st.clearOnEnds();
    }
  } // end stop 
} // end class BSTween

