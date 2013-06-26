/*
class PVSTween2 {
  ArrayList<FST> tweensX = new ArrayList<FST>();
  ArrayList<FST> tweensY = new ArrayList<FST>();
  ArrayList<FST> tweensZ = new ArrayList<FST>();
  FST initialTweenX;
  FST initialTweenY;
  FST initialTweenZ;
  float influenceMultiplier = 1;
  PVector valuePV = new PVector();

  STween base;

  // targets
  ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

  PVSTween (int duration_, int delay_, PVector startPV_, PVector endPV_) {
    base = new STween(10, 0);
    initialTweenX = new FST(duration_, delay_, startPV_.x, endPV_.x);
    initialTweenY = new FST(duration_, delay_, startPV_.y, endPV_.y);
    initialTweenZ = new FST(duration_, delay_, startPV_.z, endPV_.z);
    initialTweenX = setToBaseMode(initialTweenX);
    initialTweenY = setToBaseMode(initialTweenY);
    initialTweenZ = setToBaseMode(initialTweenZ);
    valuePV = startPV_.get();
    tweensX.add(initialTweenX);
    tweensY.add(initialTweenY);
    tweensZ.add(initialTweenZ);
  } // end constructor

  void setModeLinear () {
    base.setModeLinear();
    initialTweenX = setToBaseMode(initialTweenX);
    initialTweenY = setToBaseMode(initialTweenY);
    initialTweenZ = setToBaseMode(initialTweenZ);
  } // end setModeLinear
  void setModeCubicBoth() {
    base.setModeCubicBoth();
    initialTweenX = setToBaseMode(initialTweenX);
    initialTweenY = setToBaseMode(initialTweenY);
    initialTweenZ = setToBaseMode(initialTweenZ);
  } // end setModeCubic
  void setModeQuadBoth() {
    base.setModeQuadBoth();
    initialTweenX = setToBaseMode(initialTweenX);
    initialTweenY = setToBaseMode(initialTweenY);
    initialTweenZ = setToBaseMode(initialTweenZ);
  } // end setModeQuadBot
  void setModeQuarticBoth() {
    base.setModeQuarticBoth();
    initialTweenX = setToBaseMode(initialTweenX);
    initialTweenY = setToBaseMode(initialTweenY);
    initialTweenZ = setToBaseMode(initialTweenZ);
  } // end setModeQuarticBoth
  void setModeQuintIn() {
    base.setModeQuintIn();
    initialTweenX = setToBaseMode(initialTweenX);
    initialTweenY = setToBaseMode(initialTweenY);
    initialTweenZ = setToBaseMode(initialTweenZ);
  } // end setModeQuintIn

  void play() {
    tweensX = new ArrayList<FST>();
    tweensY = new ArrayList<FST>();
    tweensZ = new ArrayList<FST>();
    initialTweenX.play();
    initialTweenY.play();
    initialTweenZ.play();
    tweensX.add(initialTweenX);
    tweensY.add(initialTweenY);
    tweensZ.add(initialTweenZ);
  } // end play

  void pause() {
    for (int i = 0; i < tweensX.size(); i++) {
      tweensX.get(i).pause();
      tweensY.get(i).pause();
      tweensZ.get(i).pause();
    }
  } // end pause

    void resume() {
    for (int i = 0; i < tweensX.size(); i++) {
      tweensX.get(i).play();
      tweensY.get(i).play();
      tweensZ.get(i).play();
    }
  } // end resume

  void setBegin(PVector valueIn) {
    tweensX.get(tweensX.size() - 1).setBegin(valueIn.x);
    tweensY.get(tweensY.size() - 1).setBegin(valueIn.y);
    tweensZ.get(tweensZ.size() - 1).setBegin(valueIn.z);
  } // end setBegin

  void setEnd(PVector valueIn) {
    tweensX.get(tweensX.size() - 1).setEnd(valueIn.x);
    tweensY.get(tweensY.size() - 1).setEnd(valueIn.y);
    tweensZ.get(tweensZ.size() - 1).setEnd(valueIn.z);
  } // end setEnd() {

  PVector getBegin() {
    PVector newVector = new PVector();
    newVector.x = tweensX.get(tweensX.size() - 1).getBegin();
    newVector.y = tweensY.get(tweensY.size() - 1).getBegin();
    newVector.z = tweensZ.get(tweensZ.size() - 1).getBegin(); 
    return newVector;
  } // end getBegin

  PVector getEnd () {
    PVector newVector = new PVector();
    newVector.x = tweensX.get(tweensX.size() - 1).getEnd();
    newVector.y = tweensY.get(tweensY.size() - 1).getEnd();
    newVector.z = tweensZ.get(tweensZ.size() - 1).getEnd(); 
    return newVector;
  } // end getEnd  

  int getDuration() {
    return tweensX.get(tweensX.size() - 1).getDuration();
  } // end getDuration

    int getDelay() {
    return tweensX.get(tweensX.size() - 1).getDelay();
  } // end getDelay

    void setInfluenceMultiplier (float influenceMultiplierIn) {
    influenceMultiplier = influenceMultiplierIn;
  } // end setInfluenceDuration

    void playLive(PVector valueIn) {
    FST lastXTween = tweensX.get(tweensX.size() - 1);
    playLive(valueIn, lastXTween.getDuration(), 0);
  } // end playLive
  void playLive(PVector valueIn, int durationIn, int delayIn) {
    FST lastXTween = tweensX.get(tweensX.size() - 1);
    FST lastYTween = tweensY.get(tweensY.size() - 1);
    FST lastZTween = tweensZ.get(tweensZ.size() - 1);
    if ((valueIn.x - lastXTween.getEnd() != 0) || (valueIn.y - lastYTween.getEnd() != 0) || (valueIn.z - lastZTween.getEnd() != 0)) {
      if (!isPlaying()) {
        tweensX = new ArrayList<FST>();
        tweensY = new ArrayList<FST>();
        tweensZ = new ArrayList<FST>();
        initialTweenX = new FST(durationIn, delayIn, lastXTween.value(), valueIn.x);
        initialTweenY = new FST(durationIn, delayIn, lastYTween.value(), valueIn.y);
        initialTweenZ = new FST(durationIn, delayIn, lastZTween.value(), valueIn.z);
        initialTweenX = setToBaseMode(initialTweenX);
        initialTweenY = setToBaseMode(initialTweenY);
        initialTweenZ = setToBaseMode(initialTweenZ);        
        initialTweenX.play();
        initialTweenY.play();
        initialTweenZ.play();
        tweensX.add(initialTweenX);
        tweensY.add(initialTweenY);
        tweensZ.add(initialTweenZ);
      }
      else {
        tweensX.get(tweensX.size() - 1).startReducingInfluence(influenceMultiplier, durationIn);
        tweensY.get(tweensY.size() - 1).startReducingInfluence(influenceMultiplier, durationIn);
        tweensZ.get(tweensZ.size() - 1).startReducingInfluence(influenceMultiplier, durationIn);
        FST newTweenX = new FST(durationIn, delayIn, lastXTween.value(), valueIn.x);
        FST newTweenY = new FST(durationIn, delayIn, lastYTween.value(), valueIn.y);
        FST newTweenZ = new FST(durationIn, delayIn, lastZTween.value(), valueIn.z);
        newTweenX = setToBaseMode(newTweenX);
        newTweenY = setToBaseMode(newTweenY);
        newTweenZ = setToBaseMode(newTweenZ);        
        newTweenX.play();
        newTweenY.play();
        newTweenZ.play();
        newTweenX.startInfluence(lastXTween.value(), lastXTween.getEnd(), influenceMultiplier);
        newTweenY.startInfluence(lastYTween.value(), lastYTween.getEnd(), influenceMultiplier);
        newTweenZ.startInfluence(lastZTween.value(), lastZTween.getEnd(), influenceMultiplier);
        tweensX.add(newTweenX);
        tweensY.add(newTweenY);
        tweensZ.add(newTweenZ);
      }
    }
  } // end playLive


  PVector value() {
    if (tweensX.size() == 1) {
      valuePV.x = tweensX.get(tweensX.size() - 1).value();
      valuePV.y = tweensY.get(tweensY.size() - 1).value();
      valuePV.z = tweensZ.get(tweensZ.size() - 1).value();
    }
    else {
      float totalInfluence = 0f;
      valuePV = new PVector();
      for (FST t : tweensX) totalInfluence += t.getInfluence();
      for (int i = tweensX.size() - 1; i >= 0; i--) {
        float calculatedInfluence = tweensX.get(i).getInfluence() / totalInfluence;
        if (calculatedInfluence <= 0 && tweensX.get(i).inReductionStage) {
          tweensX.remove(i);
          tweensY.remove(i);
          tweensZ.remove(i);
          continue;
        }
        else {
          valuePV.x += calculatedInfluence * tweensX.get(i).value();
          valuePV.y += calculatedInfluence * tweensY.get(i).value();
          valuePV.z += calculatedInfluence * tweensZ.get(i).value();
        }
      }
    }

    // look for and assign any nextTargets

    if (!isPlaying() && isDone() && nextTargets.size() > 0) {
      NextTarget nextTarget = nextTargets.get(0);
      nextTargets.remove(0);
      PVector nextTar = (PVector)nextTarget.getTarget();
      initialTweenX = new FST(nextTarget.getDuration(), nextTarget.getDelay(), tweensX.get(0).value(), nextTar.x);
      initialTweenY = new FST(nextTarget.getDuration(), nextTarget.getDelay(), tweensY.get(0).value(), nextTar.y);
      initialTweenZ = new FST(nextTarget.getDuration(), nextTarget.getDelay(), tweensZ.get(0).value(), nextTar.z);
      initialTweenX = setToBaseMode(initialTweenX);
      initialTweenY = setToBaseMode(initialTweenY);
      initialTweenZ = setToBaseMode(initialTweenZ);        
      initialTweenX.play();
      initialTweenY.play();
      initialTweenZ.play();
      tweensX = new ArrayList<FST>();
      tweensY = new ArrayList<FST>();
      tweensZ = new ArrayList<FST>();
      tweensX.add(initialTweenX);
      tweensY.add(initialTweenY);
      tweensZ.add(initialTweenZ);
    }     

    return valuePV;
  } // end value


  boolean isPlaying() {
    for (FST f : tweensX) if (f.isPlaying()) return true;
    for (FST f : tweensY) if (f.isPlaying()) return true;
    for (FST f : tweensZ) if (f.isPlaying()) return true;
    return false;
  } // end isPlaying

  boolean isDone() {
    if (tweensX.size() == 1 && tweensX.get(0).isDone() && tweensY.size() == 1 && tweensY.get(0).isDone() && tweensZ.size() == 1 && tweensZ.get(0).isDone()) return true;
    return false;
  } // end isDone

    void addNextTarget(Object valueIn) {
    addNextTarget(tweensX.get(tweensX.size() - 1).getDuration(), tweensX.get(tweensX.size() - 1).getDelay(), valueIn);
  } // end addNextTarget
  void addNextTarget(int durationIn, int delayIn, Object valueIn) {
    NextTarget newTarget = new NextTarget(durationIn, delayIn, valueIn);
    nextTargets.add(newTarget);
  } // end addNextTarget

    FST setToBaseMode(FST fstIn) {
    fstIn.setMode(base.mode);
    return fstIn;
  } // end setToBaseMode
} // end class PVSTween
*/

