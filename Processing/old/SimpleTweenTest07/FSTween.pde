// Float SimpleTween
class FSTween extends STweenManager {

  FSTween (float duration_, float delay_, float startF_, float endF_) {
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
    playLive(valueIn, super.getDuration(), 0);
  } // end playLive
  void playLive(float valueIn, float durationIn, float delayIn) {
    super.playLive(breakUp(valueIn), durationIn, delayIn);
  } // end playLive

  public void jitter(float valueIn) {
    STween lastTween = super.allTweens.get(0);
    jitter(valueIn, lastTween.getDuration() / 4f, 0);
  } // end jitter
  public void jitter(float valueIn, float durationIn, float delayIn) {
    super.jitter(breakUp(valueIn), durationIn, delayIn);
  } // end jitter

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
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, super.getTimeMode());
  } // end addNextTarget
  void addNextTarget(float valueIn, int timeModeIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, timeModeIn);
  } // end addNextTarget
  void addNextTarget(float durationIn, float delayIn, float valueIn, int timeModeIn) {
    super.addNextTarget(durationIn, delayIn, breakUp(valueIn), timeModeIn);
  } // end addNextTarget
} // end class FSTween 

