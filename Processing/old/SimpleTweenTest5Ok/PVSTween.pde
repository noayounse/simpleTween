class PVSTween extends GenericSTween {

  PVSTween (int duration_, int delay_, PVector startPV_, PVector endPV_) {
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
    FST lastTween = super.allTweens.get(allTweens.size() -1).get(0);
    playLive(valueIn, lastTween.getDuration(), 0);
  } // end playLive
  void playLive(PVector valueIn, int durationIn, int delayIn) {
    super.playLive(breakUp(valueIn), durationIn, delayIn);
  } // end playLive

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
    FST lastTween = super.allTweens.get(allTweens.size() - 1).get(0);
    addNextTarget(lastTween.getDuration(), lastTween.getDelay(), valueIn);
  } // end addNextTarget
  void addNextTarget(int durationIn, int delayIn, PVector valueIn) {
    super.addNextTarget(durationIn, delayIn, breakUp(valueIn));
  } // end addNextTarget
} // end class PVSTween

