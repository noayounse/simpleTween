class FSTween {
  ArrayList<FST> tweens = new ArrayList<FST>();
  FST initialTween;
  float influenceMultiplier = 1;
  float valueF = 0f;

  STween base;

  // targets
  ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

  FSTween (int duration_, int delay_, float startFloat_, float endFloat_) {
    base = new STween(10, 0);
    initialTween = new FST(duration_, delay_, startFloat_, endFloat_);
    initialTween = setToBaseMode(initialTween);
    float valueF = startFloat_;
    tweens.add(initialTween);
  } // end constructor

  void setModeLinear () {
    base.setModeLinear();
    initialTween = setToBaseMode(initialTween);
  } // end setModeLinear
  void setModeCubicBoth() {
    base.setModeCubicBoth();
    initialTween = setToBaseMode(initialTween);
  } // end setModeCubic
  void setModeQuadBoth() {
    base.setModeQuadBoth();
    initialTween = setToBaseMode(initialTween);
  } // end setModeQuadBot
  void setModeQuarticBoth() {
    base.setModeQuarticBoth();
    initialTween = setToBaseMode(initialTween);
  } // end setModeQuarticBoth
  void setModeQuintIn() {
    base.setModeQuintIn();
    initialTween = setToBaseMode(initialTween);
  } // end setModeQuintIn
 

    // play will essentially clear everything and play the original tween
  void play() {
    tweens = new ArrayList<FST>();
    initialTween.play();
    tweens.add(initialTween);
  } // end play

  void pause() {
    for (int i = 0; i < tweens.size(); i++) {
      tweens.get(i).pause();
    }
  } // end pause

    void resume() {
    for (int i = 0; i < tweens.size(); i++) {
      tweens.get(i).play();
    }
  } // end resume

  void setBegin(float valueIn) {
    tweens.get(tweens.size() - 1).setBegin(valueIn);
  } // end setBegin

    void setEnd(float valueIn) {
    tweens.get(tweens.size() - 1).setEnd(valueIn);
  } // end setEnd() {

  float getBegin() {
    return tweens.get(tweens.size() - 1).getBegin();
  } // end getBegin

    float getEnd () {
    return tweens.get(tweens.size() - 1).getEnd();
  } // end getEnd  

    int getDuration() {
    return tweens.get(tweens.size() - 1).getDuration();
  } // end getDuration

    int getDelay() {
    return tweens.get(tweens.size() - 1).getDelay();
  } // end getDelay

    void setInfluenceMultiplier (float influenceMultiplierIn) {
    influenceMultiplier = influenceMultiplierIn;
  } // end setInfluenceDuration

    void playLive(float valueIn) {
    FST lastTween = tweens.get(tweens.size() - 1);
    playLive(valueIn, lastTween.getDuration(), 0);
  } // end playLive
  void playLive(float valueIn, int durationIn, int delayIn) {
    FST lastTween = tweens.get(tweens.size() - 1);
    if (valueIn - lastTween.getEnd() != 0) {
      if (!isPlaying()) {
        initialTween = new FST(durationIn, delayIn, lastTween.value(), valueIn);
        initialTween = setToBaseMode(initialTween);
        tweens = new ArrayList<FST>();
        initialTween.play();
        tweens.add(initialTween);
      }
      else {
        tweens.get(tweens.size() - 1).startReducingInfluence(influenceMultiplier, durationIn);
        FST newTween = new FST(durationIn, delayIn, lastTween.value(), valueIn);
        initialTween = setToBaseMode(initialTween);
        newTween.play();
        newTween.startInfluence(lastTween.value(), lastTween.getEnd(), influenceMultiplier);
        tweens.add(newTween);
      }
    }
  } // end playLive

  float value() {
    if (tweens.size() == 1) {
      valueF = tweens.get(tweens.size() - 1).value();
    }
    else {
      float totalInfluence = 0f;
      valueF = 0f;
      for (FST t : tweens) totalInfluence += t.getInfluence();
      for (int i = tweens.size() - 1; i >= 0; i--) {
        float calculatedInfluence = tweens.get(i).getInfluence() / totalInfluence;
        if (calculatedInfluence <= 0 && tweens.get(i).inReductionStage) {
          tweens.remove(i);
          continue;
        }
        else {
          valueF += calculatedInfluence * tweens.get(i).value();
        }
      }
    }

    // look for and assign any nextTargets

    if (!isPlaying() && isDone() && nextTargets.size() > 0) {
      NextTarget nextTarget = nextTargets.get(0);
      nextTargets.remove(0);
      initialTween = new FST(nextTarget.getDuration(), nextTarget.getDelay(), tweens.get(0).value(), (Float)nextTarget.getTarget());
      initialTween = setToBaseMode(initialTween);
      initialTween.play();
      tweens = new ArrayList<FST>();
      tweens.add(initialTween);
    }     

    return valueF;
  } // end value

  boolean isPlaying() {
    for (FST f : tweens) if (f.isPlaying()) return true;
    return false;
  } // end isPlaying

  boolean isDone() {
    if (tweens.size() == 1 && tweens.get(0).isDone()) return true;
    return false;
  } // end isDone

    void addNextTarget(Object valueIn) {
    addNextTarget(tweens.get(tweens.size() - 1).getDuration(), tweens.get(tweens.size() - 1).getDelay(), valueIn);
  } // end addNextTarget
  void addNextTarget(int durationIn, int delayIn, Object valueIn) {
    NextTarget newTarget = new NextTarget(durationIn, delayIn, valueIn);
    nextTargets.add(newTarget);
  } // end addNextTarget

    FST setToBaseMode(FST fstIn) {
    fstIn.setMode(base.mode);
    return fstIn;
  } // end setToBaseMode
} // end class FSTween

