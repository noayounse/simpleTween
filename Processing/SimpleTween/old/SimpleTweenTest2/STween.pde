class STween {
  // this will simply r
  float duration = 1f;
  float progress = 0f; // where it is along the duration
  float lastFrame = -1f;
  float percent = 0f; // progress / duration
  float delay = 0f;
  float startValue = 0f;
  float endValue = 1f;
  private float value = 1f;
  float conception = 0f;

  final int LINEAR = 0;
  final int QUAD_BOTH = 1;
  final int CUBIC_BOTH = 2;
  final int QUARTIC_BOTH = 3;
  final int QUINT_IN = 20;
  int mode = QUAD_BOTH; // default

  boolean isPlaying = false; 

  // redirect
  STween redirectTween = null;
  boolean inRedirect = false;
  float redirectNewTarget = 0f;
  float redirectOldTarget = 0f;

  STween (float duration_, float delay_, float startValue_, float endValue_) {
    duration = duration_;
    delay = delay_;
    startValue = startValue_;
    value = startValue;
    endValue = endValue_;
  } // end Constructor

  void setModeLinear () {
    mode = LINEAR;
  } // end setModeLinear
  void setModeCubicBoth() {
    mode = CUBIC_BOTH;
  } // end setModeCubic
  void setModeQuadBoth() {
    mode = QUAD_BOTH;
  } // end setModeQuadBot
  void setModeQuarticBoth() {
    mode = QUARTIC_BOTH;
  } // end setModeQuarticBoth
  void setModeQuintIn() {
    mode = QUINT_IN;
  } // end setModeQuintIn

  void play() {
    if (!isPlaying && progress > 0) conception -= delay;
    else if (!isPlaying) conception = frameCount;
    if (progress == duration || isPlaying) progress = 0;
    if (redirectTween != null) redirectTween.play();
    isPlaying = true;
  } // end play

  void playLive(float valueIn) {
    if (valueIn != endValue) {
      if (isPlaying) {
        redirect(valueIn);
      }
      else {
        setBegin(value);
        setEnd(valueIn);
        play();
      }
    }
  } // end playFromNewBeginning

  void pause() {
    isPlaying = false;
    if (redirectTween != null) redirectTween.pause();
  } // end 

  boolean isPlaying() {
    return isPlaying;
  } // end isPlaying

    void setBegin(float valueIn) {
    progress = 0;
    startValue = valueIn;
  } // end setBegin

    void setEnd (float valueIn) {
    setBegin(value);
    endValue = valueIn;
  } // end setEnd

  void setDuration(float durationIn) {
    duration = durationIn;
  } // end setDuration

    float getProgress () {
    return progress;
  } // end getProgress

    boolean isDone () {
    if (progress == duration) return true;
    return false;
  } // end isDone

    float valueST() {
    updateRedirect();
    if (isPlaying && progress >= duration) {
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
    if (redirectTween != null) if (progress == duration && redirectTween.isPlaying()) percent = (float)(progress + (redirectTween.progress - (conception + duration - redirectTween.conception))) / duration;
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

  void redirect(float valueIn) {
    if (isPlaying && redirectTween == null) { // for now only one redirect is allowed because more than one looks crappy
      //redirectTween = new STween(duration - progress - 1, 0, 0, 1);
      redirectTween = new STween(duration, 0, 0, 1);
      redirectTween.mode = mode;
      redirectTween.play();
      redirectNewTarget = valueIn;
      redirectOldTarget = endValue;
      inRedirect = true;
    }
  } // end redirect

  void updateRedirect() {
    if (inRedirect) {
      if (redirectTween.isDone()) {
        endValue = redirectNewTarget;
        inRedirect = false;
        redirectTween = null;
      }
      else {
        endValue = (redirectTween.valueST() * redirectNewTarget + (1 - redirectTween.valueST()) * redirectOldTarget);
      }
    }
  } // end updateRedirect

    String toString () {
    return frameCount + " - tween percent: " +  nf(percent, 0, 3) + " duration: " + duration + " start: " + startValue + " end: " + endValue + " isPlaying: " + isPlaying + " value: " + value + " conception: " + conception + " delay: " + delay;
  } // end toString
} // end class SimpleTween

