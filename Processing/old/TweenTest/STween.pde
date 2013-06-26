class STween {
  int duration = 0;
  int delay = 0;
  int conception = 0;
  int lastFrame = 0;

  boolean isPlaying = false;
  boolean hasStarted = false;
  boolean paused = false;

  float currentValue = 0f;
  float startValue, endValue;
  float originalStartValue, originalEndValue;
  int originalDuration, originalDelay;

  float[][] steps = new float[0][0];
  int[] stepCounters = new int[0];

  final int LINEAR = 0;
  final int QUAD_BOTH = 1;
  final int CUBIC_BOTH = 2;
  final int QUARTIC_BOTH = 3;
  final int QUINT_IN = 20;
  final int CUBIC_IN = 22;
  final int CUBIC_OUT = 23;
  int mode = CUBIC_BOTH; // default

  STween (int duration_, int delay_, float startValue_, float endValue_) {
    currentValue = startValue_;
    startValue = startValue_;
    endValue = endValue_;
    conception = frameCount;
    duration = duration_;
    delay = delay_;
    lastFrame = frameCount;
    originalStartValue = startValue_;
    originalEndValue = endValue_;
    originalDuration = duration_;
    originalDelay = delay_;
  } // end constructor

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

  void setBegin(float startIn) {
    startValue = startIn;
  } // end setBegin

    void setEnd(float endIn) {
    endValue = endIn;
  } // end endIn
  
  void setDuration(int durationIn) {
    duration = durationIn;
  } // end setDuration
  
  void setDelay(int delayIn) {
    delay = delayIn;
  } // end setDelay

    float getBegin() {
    return startValue;
  } // end getBegin

  float getEnd () {
    return endValue;
  } // end getEnd

  float getCurrent() {
    return currentValue;
  } // end getCurrent

  void play() {
    if (isPlaying && paused) {
      paused = false;
    }
    else {
      isPlaying = true;
      hasStarted = true;
      lastFrame = frameCount - 1;
      currentValue = startValue;    
      resetSteps();
      calculateSteps();
    }
  } // end play

  void pause() {
    if (isPlaying) paused = true;
  } // end pause
  
  void reset() {
      isPlaying = false;
      paused = false;
      hasStarted = false;
      setBegin(originalStartValue);
      setEnd(originalEndValue);
      setDuration(originalDuration);
      setDelay(originalDelay);
      currentValue = startValue;
      resetSteps();
  } // end reset
  
  boolean isPaused() {
    return paused;
  } // end isPaused

    void playLive(float endValueIn) {
    playLive(endValueIn, duration, 0);
  }
  void playLive (float endValueIn, int durationIn, int delayIn) {
    if (endValueIn != endValue) {
      hasStarted = true;
      if (isPlaying) {
        startValue = endValue;
      }
      else {
        resetSteps();
        startValue = currentValue;
      }
      endValue = endValueIn;
      duration = durationIn;
      delay = delayIn;
      calculateSteps();
      isPlaying = true;
      paused = false;
    }
  } // end makeNewTarget

  void resetSteps() {
    steps = new float[0][0];
    stepCounters = new int[0];
  } 

  void calculateSteps() {
    float[] newSteps = new float[duration];
    float[] allSteps = new float[delay + duration];
    for (int i = 0; i < delay; i++) {
      allSteps[i] = 0;
    } 
    for (int i = 1; i < duration + 1; i++) {
      float thisStep = getStep(i);
      newSteps[i - 1] = thisStep;
    } 
    for (int i = newSteps.length - 1; i>= 1; i--) {
      newSteps[i] -= newSteps[i - 1];
    } 
    newSteps[0] -= startValue;

    for (int i = 0; i < newSteps.length; i++) allSteps[delay + i] = newSteps[i];

    steps = (float[][])append(steps, allSteps);
    stepCounters = (int[])append(stepCounters, 0);
  } // end calculateSteps


  float value() {
    if (hasSteps()) {
      for (int i = 0; i < stepCounters.length; i++) {
        if (stepCounters[i] < steps[i].length) {
          if (frameCount != lastFrame && !paused) {
            currentValue += steps[i][stepCounters[i]];
            stepCounters[i]++;
          }
        }
      }
      if (frameCount != lastFrame) lastFrame = frameCount;
    }
    else {
      isPlaying = false;
    } 
    return currentValue;
  }

  boolean hasSteps() {
    if (getStepCount() > 0) return true;
    return false;
  } // end hasSteps

  int getStepCount() {
    int count = 0;
    for (int i = 0; i < stepCounters.length; i++) {
      if (stepCounters[i] < steps[i].length) {
        count++;
      }
    }
    return count;
  } // end getStepCount

    boolean isPlaying() {
    if (hasSteps() && isPlaying) return true;
    return false;
  } // end isPlaying

  boolean isDone() {
    if (!hasSteps()) return true;
    return false;
  } // end isDone

    boolean hasStarted() {
    return hasStarted;
  } // end hasStarted

    void resetHasStarted() {
    hasStarted = false;
  } // end resetHasStarted

  int getDuration() {
    return duration;
  } // end getDuration

    int getDelay() {
    return delay;
  } // end getDelay

    float getStep(int progressIn) {
    float thisStep = 0f;
    // see http://www.gizma.com/easing/
    // t = current time -- frameCount - conception
    // b = start value -- startValue
    // c = change in value -- (endValue - startValue)
    // d = duration -- duration
    float t = progressIn;
    float c = endValue - startValue;
    float d = duration;
    float b = startValue;
    switch (mode) {
    case LINEAR :
      thisStep = c*t/d + b; 
      break;
    case QUAD_BOTH : 
      t /= d/2;
      if (t < 1) thisStep = c/2*t*t + b;
      else {
        t--;
        thisStep = -c/2 * (t*(t-2) - 1) + b;
      }
      break;
    case CUBIC_BOTH : 
      t /= d/2;
      if (t < 1) thisStep = c/2*t*t*t + b;
      else {
        t-=2;
        thisStep = c/2*(t*t*t + 2) + b;
      }
      break;      
    case CUBIC_IN : 
      t /= d;
      thisStep = c*t*t*t + b;
      break;
    case CUBIC_OUT : 
      t /= d;
      t--;
      thisStep = c*(t*t*t + 1) + b;      
      break;      
    case QUARTIC_BOTH :
      t /= d/2;
      if (t < 1) thisStep = c/2*t*t*t*t + b;
      else {
        t -= 2;
        thisStep = -c/2 * (t*t*t*t - 2) + b;
      }
      break;
    case QUINT_IN :
      t /= d;
      thisStep = c*t*t*t*t*t + b;
      break;
    } // end switch
    return thisStep;
  } // end getStep
} // end class FST

