class CSTween extends GenericSTween {

  CSTween (int duration_, int delay_, color startColor_, color endColor_) {
    super(4); // 4 for colors - rgba
    setInitialTweens(duration_, delay_, breakUp(startColor_), breakUp(endColor_));
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
    FST lastTween = super.allTweens.get(allTweens.size() -1).get(0);
    playLive(valueIn, lastTween.getDuration(), 0);
  } // end playLive
  void playLive(color valueIn, int durationIn, int delayIn) {
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
    FST lastTween = super.allTweens.get(allTweens.size() - 1).get(0);
    addNextTarget(lastTween.getDuration(), lastTween.getDelay(), valueIn);
  } // end addNextTarget
  void addNextTarget(int durationIn, int delayIn, color valueIn) {
    super.addNextTarget(durationIn, delayIn, breakUp(valueIn));
  } // end addNextTarget
} // end class PVSTween

