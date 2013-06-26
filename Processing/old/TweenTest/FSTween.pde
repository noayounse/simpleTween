class FSTween extends STweenManager {

  FSTween (int duration_, int delay_, float startF_, float endF_) {
    super(1); // define the degree here... float = 1, pvector = 3, color = 4
    setInitialTweens(duration_, delay_, breakUp(startF_), breakUp(endF_));
  } // end constructor

  void setBegin(float valueIn) {
    float[] brokenValues = breakUp(valueIn);
    super.setBegin(brokenValues);
  } // end setBegin

  void setEnd(float valueIn) {
    float[] brokenValues = breakUp(valueIn);
    super.setEnd(brokenValues);
  } // end setEnd

  float getBegin() {
    float[] broken = super.getBrokenBegin();
    return compose(broken);
  } // end getPVectorBegin  

    float getEnd() {
    float[] broken = super.getBrokenEnd();
    return compose(broken);
  } // end getPVectorEnd

  void playLive(float valueIn) {
    //STween lastTween = super.allTweens.get(allTweens.size() -1).get(0);
    playLive(valueIn, super.getDuration(), 0);
  } // end playLive
  void playLive(float valueIn, int durationIn, int delayIn) {
    super.playLive(breakUp(valueIn), durationIn, delayIn);
  } // end playLive

  float value() {
    float[] broken = super.valueFloatArray();
    return compose(broken);
  } // end valuePVector

  float[] breakUp (float in) {
    float[] broken = new float[1];
    broken[0] = in;
    return broken;
  } // end breakUpPVector
  float compose (float[] floatsIn) {
    return floatsIn[0];
  } // end composePVector


  void addNextTarget(float valueIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn);
  } // end addNextTarget
  void addNextTarget(int durationIn, int delayIn, float valueIn) {
    super.addNextTarget(durationIn, delayIn, breakUp(valueIn));
  } // end addNextTarget
} // end class FSTween 

