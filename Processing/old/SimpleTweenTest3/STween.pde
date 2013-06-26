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
  int mode = QUAD_BOTH; // default

  boolean isPlaying = false; 

  // redirect
  STween redirectTween = null;
  boolean inRedirect = false;
  float redirectNewTarget = 0f;
  float redirectOldTarget = 0f;
  int redirectNewDuration = 0;
  int redirectOldDuration = 0;

  // targets
  ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

  STween (int duration_, int delay_) {
    duration = duration_;
    redirectOldDuration = duration; // like a backup
    delay = delay_;
    value = startValue;
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

  void pause() {
    isPlaying = false;
    if (redirectTween != null) redirectTween.pause();
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

  void addNextTarget(Object valueIn) {
    addNextTarget(valueIn, redirectOldDuration, delay);
  } // end addNextTarget
  void addNextTarget(Object valueIn, int durationIn, int delayIn) {
    NextTarget newTarget = new NextTarget(valueIn, durationIn, delayIn);
    nextTargets.add(newTarget);
  } // end addNextTarget


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

    int getProgress () {
    return progress;
  } // end getProgress

    boolean isDone() {
    if ((progress >= duration && redirectTween == null)) return true;
    return false;
  } // end isDone


    float valueST() {
    updateRedirect();
    if (isPlaying && progress >= duration && redirectTween == null) {
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
    else if (progress == duration && redirectTween != null) {
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

  void redirect() {
    if (isPlaying && redirectTween == null) { // for now only one redirect is allowed because more than one looks crappy
      //redirectTween = new STween(duration - progress - 1, 0, 0, 1);
      redirectTween = new STween(duration, 0);
      //println ("making new reidreictTween.  should die at frame : " + (frameCount + duration));
      redirectTween.mode = mode;
      redirectTween.play();
      redirectNewTarget = 1f;
      redirectOldTarget = endValue;
      redirectNewDuration = floor((duration - (conception + duration - redirectTween.conception)));
      redirectOldDuration = duration;      
      inRedirect = true;
    }
  } // end redirect

  void updateRedirect() {
    if (inRedirect) {
      if (redirectTween.isDone() && progress >= duration) {
        endValue = redirectNewTarget;
        println("resetting old duration: " + duration);
        duration = redirectOldDuration;
        println("resetting old duration: " + duration);
        inRedirect = false;
        redirectTween = null;
      }
      else {
        endValue = (redirectTween.valueST() * redirectNewTarget + (1 - redirectTween.valueST()) * redirectOldTarget);
        duration = floor(redirectTween.valueST() * redirectNewDuration + (redirectOldDuration));
      }
    }
  } // end updateRedirect

  String toString () {
    return frameCount + " - tween percent: " +  nf(percent, 0, 3) + " duration: " + duration + " start: " + startValue + " end: " + endValue + " isPlaying: " + isPlaying + " value: " + value + " conception: " + conception + " delay: " + delay;
  } // end toString
} // end class SimpleTween

