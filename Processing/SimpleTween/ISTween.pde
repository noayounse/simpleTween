// Integer SimpleTween
class ISTween extends STweenManager {

  ISTween (float duration_, float delay_, int startI_, int endI_) {
    super(1); // define the degree here... float = 1, pvector = 3, color = 4
    setInitialTweens(duration_, delay_, breakUp((float)startI_), breakUp((float)endI_));
  } // end constructor

  void setBegin(int valueIn) {
    float[] brokenValues = breakUp((float)valueIn);
    super.setBegin(brokenValues);
  } // end setBegin

  void setEnd(int valueIn) {
    float[] brokenValues = breakUp((float)valueIn);
    super.setEnd(brokenValues);
  } // end setEnd

  int getBegin() {
    float[] broken = super.getBrokenBegin();
    return compose(broken);
  } // end getPVectorBegin  

    int getEnd() {
    float[] broken = super.getBrokenEnd();
    return compose(broken);
  } // end getPVectorEnd

  void playLive(int valueIn) {
    playLive(valueIn, super.getDuration(), 0);
  } // end playLive
  void playLive(int valueIn, float durationIn, float delayIn) {
    super.playLive(breakUp((float)valueIn), durationIn, delayIn);
  } // end playLive


  /*
  public void jitter(int valueIn) {
   STween lastTween = super.allTweens.get(0);
   jitter(valueIn, lastTween.getDuration() / 4f, 0);
   } // end jitter
   public void jitter(int valueIn, float durationIn, float delayIn) {
   super.jitter(breakUp(valueIn), durationIn, delayIn);
   } // end jitter
   */


  int value() {
    float[] broken = super.valueFloatArray();
    return compose(broken);
  } // end valuePVector

  float[] breakUp (float in) {
    float[] broken = new float[1];
    broken[0] = in;
    return broken;
  } // end breakUpPVector
  int compose (float[] floatsIn) {
    return (int)floatsIn[0];
  } // end composePVector


  void addNextTarget(int valueIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, super.getTimeMode());
  } // end addNextTarget
  void addNextTarget(int valueIn, int timeModeIn) {
    addNextTarget(super.getDuration(), super.getDelay(), valueIn, timeModeIn);
  } // end addNextTarget
  void addNextTarget(float durationIn, float delayIn, int valueIn, int timeModeIn) {
    super.addNextTarget(durationIn, delayIn, breakUp((float)valueIn), timeModeIn);
  } // end addNextTarget
} // end class FSTween 

