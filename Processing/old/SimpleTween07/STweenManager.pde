class STweenManager {
  ArrayList<STween> allTweens = new ArrayList<STween>();
  private ArrayList<STween> jitterTweens = new ArrayList<STween>();

  ArrayList<OnEnd> onEnds = new ArrayList<OnEnd>();

  float[] brokenValuesStart;
  float[] brokenValuesEnd;

  STween base;
  final int FRAMES_MODE = 1;
  final int SECONDS_MODE = 2;
  int timeMode = FRAMES_MODE;

  int degree = 1;

  private boolean adjustForFasterPlayLive = true;

  // targets
  ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

  STweenManager (int degree_) {
    base = new STween(13, 0, 0, 1);
    base.setTimeMode(timeMode);
    degree = degree_;
  } // end constructor

  void setInitialTweens (float duration_, float delay_, float[] brokenValuesStart_, float[] brokenValuesEnd_) {
    brokenValuesStart = brokenValuesStart_;
    brokenValuesEnd = brokenValuesEnd_;


    // ************************************* // 
    for (int i = 0; i < degree; i++) {
      allTweens.add(new STween(duration_, delay_, brokenValuesStart[i], brokenValuesEnd[i]));  
      allTweens.get(i).setMode(base.mode);
      jitterTweens.add(new STween(duration_ / 4, delay_, 0, 0));
      jitterTweens.get(i).setMode(base.mode);
    }
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
  public void setMode(int modeIn) {
    base.setMode(modeIn);
    for (int i = 0; i < degree; i++) allTweens.get(i).setMode(modeIn);
  } // end setMode  

  void setTimeToFrames() {
    setTimeMode(FRAMES_MODE);
  } // end setTimeToFrames
  void setTimeToSeconds() {
    setTimeMode(SECONDS_MODE);
  } // end setTimeToSeconds
  void setTimeMode(int modeIn) {
    for (int i = 0; i < degree; i++) allTweens.get(i).setTimeMode(modeIn);
    base.setTimeMode(modeIn);
  } // end setTimeMode
  int getTimeMode() {
    return base.getTimeMode();
  } // end getTimeMode

    public void toggleAdjustForFasterPlayLive() {
    adjustForFasterPlayLive = !adjustForFasterPlayLive;
  } // end toggleAdjustForFasterPlayLive
  public void setAdjustForFasterPlayLive(boolean adjustIn) {
    adjustForFasterPlayLive = adjustIn;
  } // end setAdjustForFasterPlayLive

  void play() {    
    // if there are no next targets, play the original
    if (nextTargets.size() == 0) for (int i = 0; i < degree; i++) allTweens.get(i).play();
    // otherwise play the next target
    else startNextTarget();
    // start any onEnds
    startOnEnds();
  } // end play

  void pause() {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).pause();
  } // end pause

    boolean isPaused() {
    return allTweens.get(0).isPaused();
  } // end isPaused

    void resume() {
    println("in resume");
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).resume();
  } // end resume

    void reset() {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).reset();
    nextTargets = new ArrayList<NextTarget>();
  } 

  void setBegin(float[] valuesIn) {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setBegin(valuesIn[i]);
  } // end setBegin

  void setEnd(float[] valuesIn) {
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setEnd(valuesIn[i]);
  } // end setEnd 

  void setDuration(float durationIn) {
    //if (timeMode == FRAMES_MODE) durationIn = (int)durationIn;
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setDuration(durationIn);
  } // end setDuration

    void setDelay(float delayIn) {
    // if (timeMode == FRAMES_MODE) delayIn = (int)delayIn;
    for (int i = 0; i < allTweens.size(); i++) allTweens.get(i).setDelay(delayIn);
  } // end setDelay

  float[] getBrokenBegin() {
    float[] broken = new float[degree]; 
    //for (int i = allTweens.size() - 1; i < allTweens.size(); i++)  broken[i] = allTweens.get(i).getBegin();
    for (int i = 0; i < degree; i++) broken[i] = allTweens.get(i).getBegin();
    return broken;
  } // end getBrokenBegin

    float[] getBrokenEnd() {
    float[] broken = new float[degree]; 
    //for (int i = allTweens.size() - 1; i < allTweens.size(); i++)  broken[i] = allTweens.get(i).getEnd();
    for (int i = 0; i < degree; i++) broken[i] = allTweens.get(i).getEnd();
    return broken;
  } // end getBrokenEnd 

  float getDuration() {
    return allTweens.get(0).getDuration();
  } // end getDuration

    float getDelay() {
    return allTweens.get(0).getDelay();
  } // end getDelay


    void playLive(float[] valuesIn, float durationIn, float delayIn) {
    // if (timeMode == FRAMES_MODE) durationIn = (int)durationIn;
    // if (timeMode == FRAMES_MODE) delayIn = (int)delayIn;

    float[] currentValues = new float[degree];
    for (int i = 0; i < degree; i++) currentValues[i] = allTweens.get(i).getCurrent();
    if (!isPlaying()) {
      if (nextTargets.size() == 0) {
        allTweens = new ArrayList<STween>();
        for (int i = 0; i < degree; i++) allTweens.add(new STween(durationIn, delayIn, currentValues[i], valuesIn[i]));
        for (int i = 0; i < degree; i++) allTweens.get(i).setMode(base.mode);
        for (int i = 0; i < degree; i++) allTweens.get(i).setTimeMode(base.timeMode);
        for (int i = 0; i < degree; i++) allTweens.get(i).play();
      }
      else {
        addNextTarget(durationIn, delayIn, valuesIn, base.timeMode);
        startNextTarget();
      }
    }
    else {
      for (int i = 0; i < degree; i++) {
        allTweens.get(i).playLive(valuesIn[i], durationIn, delayIn);
      }

      if (adjustForFasterPlayLive) for (int i = 0; i < degree; i++) allTweens.get(i).adjustDurations();
    }
    // start any onEnds
    startOnEnds();
  } // end playLive


  // *********** //
  private void jitter(float[] valuesIn, float durationIn, float delayIn) {
    for (int i = 0; i < degree; i++) {
      jitterTweens.get(i).playLive(valuesIn[i], durationIn/2, delayIn);
      jitterTweens.get(i).playLive(0, durationIn / 2, durationIn / 2 + delayIn);
    }
  } // end jitter



  // ************* // 
  float[] valueFloatArray() {
    float[] broken = new float[degree];
    for (int j = 0; j < degree; j++) {
      broken[j] += allTweens.get(j).value();
      broken[j] += jitterTweens.get(j).value();
    }

    // look for and assign any nextTargets
    if (hasStarted() && !isPlaying() && isDone() && nextTargets.size() > 0) {
      startNextTarget();
    }     

    if (nextTargets.size() == 0 && isDone()) resetHasStarted();
    return broken;
  } // end value

  void startNextTarget() {
    NextTarget nextTarget = nextTargets.get(0);
    nextTargets.remove(0);
    float[] nextTar = nextTarget.getTarget();
    ArrayList<STween> newDirection = new ArrayList<STween>();
    for (int i = 0; i < degree; i++) {
      STween newDir = new STween(nextTarget.duration, nextTarget.delay, allTweens.get(i).value(), nextTar[i]);
      newDir.setMode(base.mode);
      newDir.setTimeMode(nextTarget.timeMode);
      newDir.play();
      newDirection.add(newDir);
    }
    allTweens = new ArrayList<STween>();
    for (int i = 0; i < degree; i++) allTweens.add(newDirection.get(i));
  } // end startNextTarget

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

    void addNextTarget(float durationIn, float delayIn, float[] valuesIn, int timeModeIn) {
    nextTargets.add(new NextTarget (durationIn, delayIn, valuesIn, timeModeIn));
  } // end addNextTarget

  void clearTargets() {
    nextTargets = new ArrayList<NextTarget>();
  } // end clearTargets

  STween setToBaseMode(STween stIn) {
    stIn.setMode(base.mode);
    return stIn;
  } // end setToBaseMode


  // onEnd stuff
  void onEnd(Object targetObj, String functionName) {
    OnEnd newOnEnd = new OnEnd(targetObj, this, functionName);
    onEnds.add(newOnEnd);
    if (isPlaying()) startOnEnds();
  } // end onEnd

  void startOnEnds() {
    for (int i = 0; i < onEnds.size(); i++) if (!onEnds.get(i).running && !onEnds.get(i).playedThrough) onEnds.get(i).start();
  } // end startOnEnds

  void clearOnEnds() {
    println("trying to stop the onend.  size: " + onEnds.size());
    for (int i = onEnds.size() - 1; i >= 0; i--) {
    println("x onEnds.size(): " + onEnds.size());  
      if (onEnds.get(i).running) {
        onEnds.get(i).quit();
      }
      //onEnds.remove(i);
    }
  } // end clearOnEnds

  void removeFinishedOnEnds() {
    for (int i = onEnds.size() - 1; i >= 0; i--) {
      if (onEnds.get(i).playedThrough) {
        onEnds.remove(i);
      }
    }
  } // end removeFinishedOnEnds
} // end class PVSTween

