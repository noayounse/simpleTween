class GenericSTween {
  ArrayList<ArrayList<FST>> allTweens = new ArrayList<ArrayList<FST>>();
  ArrayList<FST> initialTweens = new ArrayList<FST>();

  float influenceMultiplier = 1; // how long this FST has an effect – based on the next FST's duration

  float[] brokenValuesStart;
  float[] brokenValuesEnd;

  int originalDuration = 1;
  int originalDelay = 0;

  STween base;

  int degree = 1;

  // targets
  ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

  GenericSTween (int degree_) {
    base = new STween(10, 0);

    degree = degree_;
  } // end constructor

  void setInitialTweens (int duration_, int delay_, float[] brokenValuesStart_, float[] brokenValuesEnd_) {
    originalDuration = duration_;
    originalDelay = delay_; 
    brokenValuesStart = brokenValuesStart_;
    brokenValuesEnd = brokenValuesEnd_;

    for (int i = 0; i < degree; i++) initialTweens.add(new FST(duration_, delay_, brokenValuesStart[i], brokenValuesEnd[i]));  
    for (int i = 0; i < degree; i++) initialTweens.get(i).setMode(base.mode);    

    allTweens.add(initialTweens);
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
    for (int i = 0; i < degree; i++) initialTweens.get(i).setMode(base.mode);
  } // end setMode

    void play() {
    allTweens = new ArrayList<ArrayList<FST>>();
    for (int i = 0; i < degree; i++) initialTweens.get(i).play();
    allTweens.add(initialTweens);
  } // end play

  void pause() {
    for (int i = 0; i < allTweens.size(); i++) for (int j = 0; j < degree; j++) allTweens.get(i).get(j).pause();
  } // end pause

    void resume() {
    for (int i = 0; i < allTweens.size(); i++) for (int j = 0; j < degree; j++) allTweens.get(i).get(j).play();
  } // end resume

  void setBegin(float[] valuesIn) {
    for (int i = allTweens.size() - 1; i < allTweens.size(); i++) for (int j = 0; j < degree; j++) allTweens.get(i).get(j).setBegin(valuesIn[j]);
  } // end setBegin

  void setEnd(float[] valuesIn) {
    for (int i = allTweens.size() - 1; i < allTweens.size(); i++) for (int j = 0; j < degree; j++) allTweens.get(i).get(j).setEnd(valuesIn[j]);
  } // end setEnd 

  float[] getBrokenBegin() {
    float[] broken = new float[degree]; 
    for (int i = allTweens.size() - 1; i < allTweens.size(); i++) for (int j = 0; j < degree; j++) broken[j] = allTweens.get(i).get(j).getBegin();
    return broken;
  } // end getBrokenBegin

    float[] getBrokenEnd() {
    float[] broken = new float[degree]; 
    for (int i = allTweens.size() - 1; i < allTweens.size(); i++) for (int j = 0; j < degree; j++) broken[j] = allTweens.get(i).get(j).getEnd();
    return broken;
  } // end getBrokenEnd 

  int getDuration() {
    return allTweens.get(allTweens.size() - 1).get(0).getDuration();
  } // end getDuration

    int getDelay() {
    return allTweens.get(allTweens.size() - 1).get(0).getDelay();
  } // end getDelay

    void setInfluenceMultiplier (float influenceMultiplierIn) {
    influenceMultiplier = influenceMultiplierIn;
  } // end setInfluenceDuration


    void playLive(float[] valuesIn, int durationIn, int delayIn) {
    ArrayList<FST> lastSet = allTweens.get(allTweens.size() - 1);
    boolean okToProceed = false;
    for (int i = 0; i < degree; i++) if (valuesIn[i] - lastSet.get(i).getEnd() != 0) okToProceed = true;

    if (okToProceed) {
      if (!isPlaying()) {
        allTweens = new ArrayList<ArrayList<FST>>();
        initialTweens = new ArrayList<FST>();
        for (int i = 0; i < degree; i++) initialTweens.add(new FST(durationIn, delayIn, lastSet.get(i).value(), valuesIn[i]));
        for (int i = 0; i < degree; i++) initialTweens.get(i).setMode(base.mode);
        for (int i = 0; i < degree; i++) initialTweens.get(i).play();
        allTweens.add(initialTweens);
      }
      else {
        for (int i = allTweens.size() - 1; i < allTweens.size(); i++) for (int j = 0; j < degree; j++) allTweens.get(i).get(j).startReducingInfluence(influenceMultiplier, durationIn);
        ArrayList<FST> newGroup = new ArrayList<FST>();

        for (int i = 0; i < degree; i++) {
          FST newFST = new FST(durationIn, delayIn, lastSet.get(i).value(), valuesIn[i]); 
          newFST.setMode(base.mode);
          newFST.play();
          //newFST.startInfluence(lastSet.get(i).value(), lastSet.get(i).getEnd(), influenceMultiplier);
          //newFST.startInfluence(lastSet.get(i).value(), lastSet.get(i).getEnd(), influenceMultiplier, durationIn);
          newFST.startInfluence(lastSet.get(i).value(), lastSet.get(i).getEnd(), influenceMultiplier, lastSet.get(i).getDuration() - lastSet.get(i).getProgress());
          newGroup.add(newFST);
        }
        allTweens.add(newGroup);
      }
    }
  } // end playLive


  float[] valueFloatArray() {
    float[] broken = new float[degree];
    if (allTweens.size() == 1) {
      for (int i = 0; i < degree; i++) broken[i] = allTweens.get(0).get(i).value();
    }
    else {
      float totalInfluence = 0f;
      //valuePV = new PVector();
      for (int i = 0; i < allTweens.size(); i++) totalInfluence += allTweens.get(i).get(0).getInfluence();
      for (int i = allTweens.size() - 1; i >= 0; i--) {
        float calculatedInfluence = allTweens.get(i).get(0).getInfluence() / totalInfluence;
        if (calculatedInfluence <= 0 && allTweens.get(i).get(0).isInReductionStage()) {
          allTweens.remove(i);
          continue;
        }
        else {
          for (int j = 0; j < degree; j++) broken[j] += calculatedInfluence * allTweens.get(i).get(j).value();
        }
      }
    }


    // look for and assign any nextTargets
    if (!isPlaying() && isDone() && nextTargets.size() > 0) {
      NextTarget nextTarget = nextTargets.get(0);
      nextTargets.remove(0);
      float[] nextTar = nextTarget.getTarget();
      ArrayList<FST> lastSet = allTweens.get(allTweens.size() - 1);
      ArrayList<FST> newDirection = new ArrayList<FST>();
      for (int i = 0; i < degree; i++) {
        FST newDir = new FST(nextTarget.duration, nextTarget.delay, lastSet.get(i).value(), nextTar[i]);
        newDir.setMode(base.mode);
        newDir.play();
        newDirection.add(newDir);
      }
      allTweens = new ArrayList<ArrayList<FST>>();
      initialTweens = newDirection;
      allTweens.add(newDirection);
    }     

    return broken;
  } // end value


  boolean isPlaying() {
    for (ArrayList<FST> a : allTweens) for (FST f : a) if (f.isPlaying()) return true;
    return false;
  } // end isPlaying

  boolean isDone() {
    boolean done = true;
    if (allTweens.size() == 1) {
      for (ArrayList<FST> a : allTweens) {
        for (FST f : a) {
          if (!f.isDone()) done = false;
        }
      }
    }
    else done = false;
    //if (tweensX.size() == 1 && tweensX.get(0).isDone() && tweensY.size() == 1 && tweensY.get(0).isDone() && tweensZ.size() == 1 && tweensZ.get(0).isDone()) return true;
    return done;
  } // end isDone

    void addNextTarget(int durationIn, int delayIn, float[] valuesIn) {
    nextTargets.add(new NextTarget (durationIn, delayIn, valuesIn));
  } // end addNextTarget

  FST setToBaseMode(FST fstIn) {
    fstIn.setMode(base.mode);
    return fstIn;
  } // end setToBaseMode
} // end class PVSTween

