class STween {
  private int duration = 1;
  private int progress = 0; // where it is along the duration
  float lastFrame = -1f;
  float percent = 0f; // progress / duration
  int delay = 0;
  float startValue = 0f;
  float endValue = 1f;
  private float value = 1f;
  float conception = 0f;

  final int LINEAR = 0;
  final int QUAD_BOTH = 1;
  final int CUBIC_BOTH = 2;
  final int QUARTIC_BOTH = 3;
  final int QUINT_IN = 20;
  final int CUBIC_IN = 22;
  final int CUBIC_OUT = 23;
  int mode = QUAD_BOTH; // default

  boolean isPlaying = false; 

  STween (int duration_, int delay_) {
    duration = duration_;
    delay = delay_;
    value = startValue;
  } // end Constructor

  void setModeLinear () {
    mode = LINEAR;
  } // end setModeLinear
  void setModeCubicBoth() {
    mode = CUBIC_BOTH;
  } // end setModeCubic
  void setModeCubicIn() {
    mode = CUBIC_IN;
  } // end setModeCubicIn
  void setModeCubicOut() {
    mode = CUBIC_OUT;
  } // end setModeCubicOut
  void setModeQuadBoth() {
    mode = QUAD_BOTH;
  } // end setModeQuadBot
  void setModeQuarticBoth() {
    mode = QUARTIC_BOTH;
  } // end setModeQuarticBoth
  void setModeQuintIn() {
    mode = QUINT_IN;
  } // end setModeQuintIn
  void setMode(int modeIn) {
    mode = modeIn;
  } // end setMode

  void play() {
    if (!isPlaying && progress > 0) conception -= delay;
    else if (!isPlaying) conception = frameCount;
    if (progress == duration || isPlaying) progress = 0;
    isPlaying = true;
  } // end play

  void pause() {
    isPlaying = false;
  } // end 

  boolean isPlaying() {
    return isPlaying;
  } // end isPlaying

    void setBegin(float valueIn) {
    resetProgress();
    startValue = valueIn;
  } // end setBegin

    void setEnd (float valueIn) {
    setBegin(value);
    endValue = valueIn;
  } // end setEnd

  void resetProgress () {
    progress = 0;
  } // end resetProgress

  void setDelay (int delayIn) {
    if (!isPlaying()) {
      delay = delayIn;
    }
  } // end setDelay

  void setDuration(int durationIn) {
    duration = durationIn;
  } // end setDuration

    int getDuration() {
    return duration;
  } // end getDuration

    int getDelay() {
    return delay;
  } // end getDelay

    int getProgress () {
    return progress;
  } // end getProgress

    boolean isDone() {
    if ((progress >= duration)) return true;
    return false;
  } // end isDone


    float valueST() {
    if (isPlaying && progress >= duration) {
      //println(frameCount + " toggling isPlaying to false");
      isPlaying = false;
    }
    if (isPlaying && frameCount > conception + delay) {
      if (frameCount != lastFrame) {
        progress++;
        lastFrame = frameCount;
      }
      findValue();
    }
    else if (progress == duration) {
      value = endValue;
    }
    else if (progress == 0) {
      value = startValue;
    }
    updatePercent();
    return value;
  }// end value


    void updatePercent() {
    percent = (float)progress / duration;
    //if (redirectTween != null) if (progress == duration && redirectTween.isPlaying()) percent = (float)(progress + (redirectTween.progress - (conception + duration - redirectTween.conception))) / duration;
  } // end updateMultiplierAndPercent

  void findValue() {
    // see http://www.gizma.com/easing/
    // t = current time -- frameCount - conception
    // b = start value -- startValue
    // c = change in value -- (endValue - startValue)
    // d = duration -- duration
    float t = progress;
    float c = (endValue - startValue);
    float d = duration;
    float b = startValue;
    switch (mode) {
    case LINEAR :
      value = c*t/d + b; 
      break;
    case QUAD_BOTH : 
      t /= d/2;
      if (t < 1) value = c/2*t*t + b;
      else {
        t--;
        value = -c/2 * (t*(t-2) - 1) + b;
      }
      break;
    case CUBIC_BOTH : 
      t /= d/2;
      if (t < 1) value = c/2*t*t*t + b;
      else {
        t-=2;
        value = c/2*(t*t*t + 2) + b;
      }
      break;      
    case CUBIC_IN : 
      t /= d;
      value = c*t*t*t + b;
      break;
    case CUBIC_OUT : 
      t /= d;
      t--;
      value = c*(t*t*t + 1) + b;      
      break;      
    case QUARTIC_BOTH :
      t /= d/2;
      if (t < 1) value = c/2*t*t*t*t + b;
      else {
        t -= 2;
        value = -c/2 * (t*t*t*t - 2) + b;
      }
      break;
    case QUINT_IN :
      t /= d;
      value = c*t*t*t*t*t + b;
      break;
    } // end switch
  } // end findValue

  String toString () {
    return frameCount + " - tween percent: " +  nf(percent, 0, 3) + " duration: " + duration + " start: " + startValue + " end: " + endValue + " isPlaying: " + isPlaying + " value: " + value + " conception: " + conception + " delay: " + delay;
  } // end toString
} // end class SimpleTween

