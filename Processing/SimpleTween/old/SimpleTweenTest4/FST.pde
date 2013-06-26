class FST extends STween {
  float startFloat = 0f;
  float endFloat = 1f;

  FST influence;
  boolean addingInfluence = true;
  boolean inReductionStage = false;

  boolean isRedirect = false;
  float beginStartValue, beginEndValue;

  FST(int duration_, int delay_, float startFloat_, float endFloat_) {
    super(duration_, delay_);
    startFloat = startFloat_;
    endFloat = endFloat_;
  } // end constructor

  void setBegin(float valueIn) {
    startFloat = valueIn;
  } // end setBegin

    void setEnd (float valueIn) {
    super.setBegin(0);
    endFloat = valueIn;
  } // end setEnd

  void startInfluence(float beginStartValueIn, float beginEndValueIn, float multiplierIn) {
    //influence = new STween(constrain(floor(super.getDuration() * multiplierIn), 1, super.getDuration() - 1), 0);
    influence = new FST(constrain(floor(super.getDuration() * multiplierIn), 1, super.getDuration() - 1), 0, 0f, 1f);
    influence.setModeLinear();
    influence.play();
    beginStartValue = beginStartValueIn;
    beginEndValue = beginEndValueIn; 
    isRedirect = true;
  } // end startInfluence

    void startReducingInfluence(float multiplierIn, int durationIn) {
    float oldInfluence = 1f;
    if (influence != null && influence.value() > 0) {
      oldInfluence = influence.value();
      if (influence.isPlaying()) influence.pause();
    }
    influence = new FST(constrain(floor(durationIn * multiplierIn), 1, durationIn - 1), 0, oldInfluence, 0f);
    influence.play();
    inReductionStage = true;
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
    if (multiplier == 1) valueF = endFloat;
    else if (multiplier == 0) valueF = startFloat;
    else {
      if (!isRedirect) valueF = (multiplier * endFloat) + (1 - multiplier) * startFloat;
      else {
        float modifiedStart = multiplier * beginEndValue + (1 - multiplier) * beginStartValue; 
        valueF = (multiplier * endFloat) + (1 - multiplier) * modifiedStart;
      }
    }

    return valueF;
  } // end value
  
  void setMode(int modeIn){
    super.setMode(modeIn);
  } // end setMode
} // end class FTween

