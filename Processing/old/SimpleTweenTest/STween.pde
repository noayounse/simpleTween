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
  final int CUBIC_BOTH = 1;
  final int QUARTIC_BOTH = 2;
  int mode = CUBIC_BOTH; 

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
  void setModeQuarticBoth() {
    mode = QUARTIC_BOTH;
  } // end setModeQuarticBoth

  void play() {
    isPlaying = true;
    conception = frameCount;
    if (progress == duration) progress = 0;
    if (progress > 0) conception -= delay;
    if (redirectTween != null) redirectTween.play();
  } // end play

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

  float getProgress () {
    return progress;
  } // end getProgress

    boolean isDone () {
    if (progress == duration) return true;
    return false;
  } // end isDone

    float value() {
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
    percent = constrain((float)progress / duration, 0f, 1f);
  } // end updateMultiplierAndPercent

  void findValue() {
    // see http://www.gizma.com/easing/
    // t = current time -- frameCount - conception
    // b = start value -- this is done in value - assume 1 here
    // c = change in value -- this is also done in value - assume 1 here
    // d = duration -- duration
    float t = progress;
    float c = (endValue - startValue);
    float d = duration;
    float b = startValue;
    switch (mode) {
    case LINEAR :
      value = c*t/d + b; 
      break;
    case CUBIC_BOTH : 
      t /= d/2;
      if (t < 1) value = c/2*t*t + b;
      else {
        t--;
        value = -c/2 * (t*(t-2) - 1) + b;
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
    } // end switch
  } // end findValue

  void redirect(float valueIn, float redirectTimeIn) {
    if (isPlaying) {
      redirectTween = new STween(min(duration - progress, redirectTimeIn), 0, 0, 1);
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
        println("end of redirectTween");
      }
      else {
        endValue = (redirectTween.value() * redirectNewTarget + (1 - redirectTween.value()) * redirectOldTarget);  
        println("in updateRedirect.  oritinalValue: " + redirectOldTarget + " and reidrectTarget: " + redirectNewTarget + " new endValue: " + endValue);
        println("redirectTween.percent: " + redirectTween.percent);
      }
    }
  } // end updateRedirect

    String toString () {
    return "tween percent: " +  nf(percent, 0, 3) + " duration: " + duration + " start: " + startValue + " end: " + endValue + " isPlaying: " + isPlaying + " value: " + value;
  } // end toString
} // end class SimpleTween

