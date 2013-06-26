class FST extends STween {
  float startFloat = 0f;
  float endFloat = 1f;

  FST influence;
  boolean addingInfluence = true;
  boolean inReductionStage = false;

  boolean isRedirect = false;
  float beginStartValue, beginEndValue;

  int beginDuration, endDuration;
  FST durationFST;
  FST startFST;

  FST(int duration_, int delay_, float startFloat_, float endFloat_) {
    super(duration_, delay_);
    startFloat = startFloat_;
    endFloat = endFloat_;
    beginDuration = getDuration();
    endDuration = getDuration();
  } // end constructor

  void setBegin(float valueIn) {
    startFloat = valueIn;
  } // end setBegin

    void setEnd (float valueIn) {
    super.setBegin(0);
    endFloat = valueIn;
  } // end setEnd

  //void startInfluence(float beginStartValueIn, float beginEndValueIn, float multiplierIn) {
  void startInfluence(float beginStartValueIn, float beginEndValueIn, float multiplierIn, int durationIn) {
    //influence = new STween(constrain(floor(super.getDuration() * multiplierIn), 1, super.getDuration() - 1), 0);
    //influence = new FST(constrain(floor(getDuration() * multiplierIn), 1, getDuration() - 1), 0, 0f, 1f);
    influence = new FST(durationIn, 0, 0f, 1f);
    influence.setModeQuadBoth();
    influence.play();
    beginStartValue = beginStartValueIn;
    beginEndValue = beginEndValueIn; 
    // startFST = new FST(constrain(floor(getDuration() * multiplierIn), 1, getDuration() - 1), 0, beginStartValue, beginEndValue);
    startFST = new FST(durationIn, 0, beginStartValue, beginEndValue);
    startFST.setModeQuadBoth();
    startFST.play();
    isRedirect = true;
  } // end startInfluence

    void startReducingInfluence(float multiplierIn, int durationIn) {
    float oldInfluence = 1f;
    if (influence != null && influence.value() > 0) {
      oldInfluence = influence.value();
      if (influence.isPlaying()) influence.pause();
    }
    //influence = new FST(constrain(floor(durationIn * multiplierIn), 1, durationIn - 1), 0, oldInfluence, 0f);
    //influence = new FST(durationIn, 0, oldInfluence, 0f);
    influence = new FST(super.getDuration() - super.getProgress(), 0, oldInfluence, 0f);
    influence.setModeQuadBoth();
    influence.play();
    inReductionStage = true;
    // also increase the duration...
    /* 
     endDuration = super.getProgress() + durationIn;
     durationFST = new FST(durationIn, 0, beginDuration, endDuration);
     durationFST = new FST(super.getDuration() - super.getProgress(), 0, beginDuration, endDuration);
     durationFST.setModeLinear();
     durationFST.play();
     */
  } // end startReducingInfluence

    float getInfluence() {
    if (influence == null) return 1;
    else return constrain(influence.value(), 0f, 1f);
  } // end getInfluence

  float getBegin() {
    return startFloat;
  } // end getBegin

  float getEnd () {
    return endFloat;
  } // end getEnd

  int getDuration() {
    return super.getDuration();
  } // end getDuration

    int getDelay() {
    return super.getDelay();
  } // end getDelay

    boolean isInReductionStage() {
    return inReductionStage;
  } // end isInReductionStage


    boolean isDone() {
    return super.isDone();
  } // end isDone

    void pause() {
    super.pause();
  } // end pause


    float value() {
    float valueF = 0f;
    float multiplier = super.valueST();

    // adjust the duration first

    if (endDuration != getDuration()) {
      int newDuration = (int)durationFST.value();
      //newDuration = beginDuration;
      super.setDuration(newDuration);
      println("multiplier: " + multiplier + " endDuration: " + endDuration + " beginDuration: " + beginDuration + " newDuration: " + newDuration);
    } 


    // then the value
    if (multiplier == 1) valueF = endFloat;
    else if (multiplier == 0) valueF = startFloat;
    else {
      //valueF = (multiplier * endFloat) + (1 - multiplier) * startFloat;

      if (!isRedirect) valueF = (multiplier * endFloat) + (1 - multiplier) * startFloat;
      else {
        valueF = (multiplier * endFloat) + (1 - multiplier) * startFST.value();
      }
    }

    return valueF;
  } // end value

  void setMode(int modeIn) {
    super.setMode(modeIn);
  } // end setMode
} // end class FTween

