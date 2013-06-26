// Color SimpleTween
class CSTween extends STweenManager {

  CSTween (float duration_, float delay_, color startColor_, color endColor_) {
    super(4); // 4 for colors - rgba
    setInitialTweens(duration_, delay_, breakUp(startColor_), breakUp(endColor_));
    println("end of CSTween constructor");
  } // end constructor

  void setBegin(color valueIn) {
    float[] brokenValues = breakUp(valueIn);
    super.setBegin(brokenValues);
  } // end setBegin

  void setEnd(color valueIn) {
    float[] brokenValues = breakUp(valueIn);
    super.setEnd(brokenValues);
  } // end setEnd

  color getBegin() {
    float[] broken = super.getBrokenBegin();
    return compose(broken);
  } // end getPVectorBegin  

    color getEnd() {
    float[] broken = super.getBrokenEnd();
    return compose(broken);
  } // end getPVectorEnd

  void playLive(color valueIn) {
    STween lastTween = super.allTweens.get(allTweens.size() -1);
    playLive(valueIn, lastTween.getDuration(), 0);
  } // end playLive
  void playLive(color valueIn, float durationIn, float delayIn) {
    super.playLive(breakUp(valueIn), durationIn, delayIn);
  } // end playLive

  color value() {
    float[] broken = super.valueFloatArray();
    return compose(broken);
  } // end valuePVector

  float[] breakUp (color in) {
    float[] broken = new float[4];
    broken[0] = (in >> 24) & 0xFF;
    broken[1] = (in >> 16) & 0xFF;
    broken[2] = (in >> 8) & 0xFF;
    broken[3] = (in >> 0) & 0xFF;
    return broken;
  } // end breakUp
  color compose (float[] floatsIn) {
    int redone = (int)floatsIn[0];
    redone = (int)((redone << 8) + floatsIn[1]);
    redone = (int)((redone << 8) + floatsIn[2]);
    redone = (int)((redone << 8) + floatsIn[3]);
    return redone;
  } // end compose



  void addNextTarget(color valueIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, super.getTimeMode());
  } // end addNextTarget
  void addNextTarget(color valueIn, int timeModeIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, timeModeIn);
  } // end addNextTarget
  void addNextTarget(float durationIn, float delayIn, color valueIn, int timeModeIn) {
    super.addNextTarget(durationIn, delayIn, breakUp(valueIn), timeModeIn);
  } // end addNextTarget
} // end class PVSTween

