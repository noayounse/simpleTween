// PVector SimpleTween
class PVSTween extends STweenManager {

  PVSTween (float duration_, float delay_, PVector startPV_, PVector endPV_) {
    super(3);
    setInitialTweens(duration_, delay_, breakUp(startPV_), breakUp(endPV_));
  } // end constructor

  void setBegin(PVector valueIn) {
    float[] brokenValues = breakUp(valueIn);
    super.setBegin(brokenValues);
  } // end setBegin

  void setEnd(PVector valueIn) {
    float[] brokenValues = breakUp(valueIn);
    super.setEnd(brokenValues);
  } // end setEnd

  PVector getBegin() {
    float[] broken = super.getBrokenBegin();
    return compose(broken);
  } // end getPVectorBegin  

    PVector getEnd() {
    float[] broken = super.getBrokenEnd();
    return compose(broken);
  } // end getPVectorEnd

  void playLive(PVector valueIn) {
    STween lastTween = super.allTweens.get(0);
    playLive(valueIn, lastTween.getDuration(), 0);
  } // end playLive
  void playLive(PVector valueIn, float durationIn, float delayIn) {
    super.playLive(breakUp(valueIn), durationIn, delayIn);
  } // end playLive
  
  
  // ******* //
  public void jitter(PVector valueIn) {
    STween lastTween = super.allTweens.get(0);
    jitter(valueIn, lastTween.getDuration() / 4f, 0);
  } // end jitter
  public void jitter(PVector valueIn, float durationIn, float delayIn) {
    super.jitter(breakUp(valueIn), durationIn, delayIn);
  } // end jitter
  


  PVector value() {
    float[] broken = super.valueFloatArray();
    return compose(broken);
  } // end valuePVector

  float[] breakUp (PVector in) {
    float[] broken = new float[3];
    broken[0] = in.x;
    broken[1] = in.y;
    broken[2] = in.z;
    return broken;
  } // end breakUp
  PVector compose (float[] floatsIn) {
    return new PVector(floatsIn[0], floatsIn[1], floatsIn[2]);
  } // end compose



  void addNextTarget(PVector valueIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, super.getTimeMode());
  } // end addNextTarget
  void addNextTarget(PVector valueIn, int timeModeIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, timeModeIn);
  } // end addNextTarget  
  void addNextTarget(float durationIn, float delayIn, PVector valueIn, int timeModeIn) {
    super.addNextTarget(durationIn, delayIn, breakUp(valueIn), timeModeIn);
  } // end addNextTarget
} // end class PVSTween

