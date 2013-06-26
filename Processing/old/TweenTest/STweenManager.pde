class STweenManager {
  ArrayList<STween> allTweens = new ArrayList<STween>();

  float[] brokenValuesStart;
  float[] brokenValuesEnd;

  STween base;

  int degree = 1;

  // targets
  ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

  STweenManager (int degree_) {
    base = new STween(13, 0, 0, 1);
    degree = degree_;
  } // end constructor

  void setInitialTweens (int duration_, int delay_, float[] brokenValuesStart_, float[] brokenValuesEnd_) {
    brokenValuesStart = brokenValuesStart_;
    brokenValuesEnd = brokenValuesEnd_;

    for (int i = 0; i < degree; i++) allTweens.add(new STween(duration_, delay_, brokenValuesStart[i], brokenValuesEnd[i]));  
    for (int i = 0; i < degree; i++) allTweens.get(i).setMode(base.mode);    

    //allTweens.add(initialTweens);
  }  // end setInitialTweens

  void setModeLinear () {
    base.setModeLinear();
    setMode();
  } // end setModeLinear
  void setModeCubicBoth() {
    base.setModeCubicBoth();
    setMode();
  } // end setModeCubic
  void setModeCubicIn() {
    base.setModeCubicIn();
    setMode();
  } // end setModeCubicIn()
  void setModeCubicOut() {
    base.setModeCubicOut();
    setMode();
  } // end setModeCubicOut()
  void setModeQuadBoth() {
    base.setModeQuadBoth();
    setMode();
  } // end setModeQuadBot
  void setModeQuarticBoth() {
    base.setModeQuarticBoth();
    setMode();
  } // end setModeQuarticBoth
  void setModeQuintIn() {
    base.setModeQuintIn();
    setMode();
  } // end setModeQuintIn
  void setMode() {
    for (int i = 0; i < degree; i++) allTweens.get(i).setMode(base.mode);
  } // end setMode

    void play() {    
    for (int i = 0; i < degree; i++) allTweens.get(i).play();
  } // end play

    void pause() {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).pause();
  } // end pause

    boolean isPaused() {
    return allTweens.get(0).isPaused();
  } // end isPaused

    void reset() {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).reset();
  } 

  void setBegin(float[] valuesIn) {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setBegin(valuesIn[i]);
  } // end setBegin

  void setEnd(float[] valuesIn) {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setEnd(valuesIn[i]);
  } // end setEnd 

  void setDuration(int durationIn) {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setDuration(durationIn);
  } // end setDuration

  void setDelay(int delayIn) {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setDelay(delayIn);
  } // end setDelay

  float[] getBrokenBegin() {
    float[] broken = new float[degree]; 
    for (int i = allTweens.size() - 1; i < allTweens.size(); i++)  broken[i] = allTweens.get(i).getBegin();
    return broken;
  } // end getBrokenBegin

    float[] getBrokenEnd() {
    float[] broken = new float[degree]; 
    for (int i = allTweens.size() - 1; i < allTweens.size(); i++)  broken[i] = allTweens.get(i).getEnd();
    return broken;
  } // end getBrokenEnd 

  int getDuration() {
    return allTweens.get(0).getDuration();
  } // end getDuration

    int getDelay() {
    return allTweens.get(0).getDelay();
  } // end getDelay


    void playLive(float[] valuesIn, int durationIn, int delayIn) {
    float[] currentValues = new float[degree];
    for (int i = 0; i < degree; i++) currentValues[i] = allTweens.get(i).getCurrent();
    if (!isPlaying()) {
      allTweens = new ArrayList<STween>();
      for (int i = 0; i < degree; i++) allTweens.add(new STween(durationIn, delayIn, currentValues[i], valuesIn[i]));
      for (int i = 0; i < degree; i++) allTweens.get(i).setMode(base.mode);
      for (int i = 0; i < degree; i++) allTweens.get(i).play();
    }
    else {
      for (int i = 0; i < degree; i++) {
        allTweens.get(i).playLive(valuesIn[i], durationIn, delayIn);
      }
    }
  } // end playLive


  float[] valueFloatArray() {
    float[] broken = new float[degree];
    for (int j = 0; j < degree; j++) broken[j] += allTweens.get(j).value();

    // look for and assign any nextTargets
    if (hasStarted() && !isPlaying() && isDone() && nextTargets.size() > 0) {

      NextTarget nextTarget = nextTargets.get(0);
      nextTargets.remove(0);
      float[] nextTar = nextTarget.getTarget();
      ArrayList<STween> newDirection = new ArrayList<STween>();
      for (int i = 0; i < degree; i++) {
        STween newDir = new STween(nextTarget.duration, nextTarget.delay, allTweens.get(i).value(), nextTar[i]);
        newDir.setMode(base.mode);
        newDir.play();
        newDirection.add(newDir);
      }
      allTweens = new ArrayList<STween>();
      for (int i = 0; i < degree; i++) allTweens.add(newDirection.get(i));
    }     

    if (nextTargets.size() == 0) resetHasStarted();
    return broken;
  } // end value


  boolean isPlaying() {
    for (STween st : allTweens) if (st.isPlaying()) return true;
    return false;
  } // end isPlaying

  boolean isDone() {
    boolean done = true;
    for (STween st : allTweens) {
      if (!st.isDone()) done = false;
    }
    return done;
  } // end isDone

    boolean hasStarted() {
    for (STween st : allTweens) if (st.hasStarted()) return true;
    return false;
  } // end hasStarted

  void resetHasStarted() {
    for (int i = 0; i < degree; i++) allTweens.get(i).resetHasStarted();
  } // end resetHasStarted

    void addNextTarget(int durationIn, int delayIn, float[] valuesIn) {
    nextTargets.add(new NextTarget (durationIn, delayIn, valuesIn));
  } // end addNextTarget

  STween setToBaseMode(STween stIn) {
    stIn.setMode(base.mode);
    return stIn;
  } // end setToBaseMode
} // end class PVSTween

