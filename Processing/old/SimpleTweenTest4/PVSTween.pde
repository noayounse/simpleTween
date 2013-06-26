class PVSTween extends GenericSTween {

  PVSTween (int duration_, int delay_, PVector startPV_, PVector endPV_) {
    super(3);
    setInitialTweens(duration_, delay_, breakUpPVector(startPV_), breakUpPVector(endPV_));
  } // end constructor

  void setBegin(PVector valueIn) {
    float[] brokenValues = breakUpPVector(valueIn);
    super.setBegin(brokenValues);
  } // end setBegin

  void setEnd(PVector valueIn) {
    float[] brokenValues = breakUpPVector(valueIn);
    super.setEnd(brokenValues);
  } // end setEnd

  PVector getPVectorBegin() {
    float[] broken = super.getBrokenBegin();
    return composePVector(broken);
  } // end getPVectorBegin  

    PVector getPVectorEnd() {
    float[] broken = super.getBrokenEnd();
    return composePVector(broken);
  } // end getPVectorEnd

  void playLive(PVector valueIn) {
    FST lastTween = super.allTweens.get(allTweens.size() -1).get(0);
    playLive(valueIn, lastTween.getDuration(), 0);
  } // end playLive
  void playLive(PVector valueIn, int durationIn, int delayIn) {
    super.playLive(breakUpPVector(valueIn), durationIn, delayIn);
  } // end playLive

  PVector value() {
    float[] broken = super.valueFloatArray();
    return composePVector(broken);
  } // end valuePVector

  float[] breakUpPVector (PVector vectorIn) {
    float[] broken = new float[3];
    broken[0] = vectorIn.x;
    broken[1] = vectorIn.y;
    broken[2] = vectorIn.z;
    return broken;
  } // end breakUpPVector
  PVector composePVector (float[] floatsIn) {
    return new PVector(floatsIn[0], floatsIn[1], floatsIn[2]);
  } // end composePVector
} // end class PVSTween

