public final float[] EASE_LINEAR = {
  .25, .25, .75, .75
}; 
public final float[] EASE_IN_OUT = {
  .75, 0, .25, 1
};
public final float[] EASE_OUT = {
  0, 0, .5, 1
};
public final float[] EASE_IN = {
  .5, 0, 1, 1
};


// SimpleTween
class STween {
  float duration = 0;
  float delay = 0;
  float lastFrame = 0;

  final int FRAMES_MODE = 1;
  final int SECONDS_MODE = 2;
  int timeMode = FRAMES_MODE;

  boolean isPlaying = false;
  boolean hasStarted = false;
  boolean paused = false;
  boolean isDone = false;



  float currentValue = 0f;
  float startValue, endValue;
  float originalStartValue, originalEndValue;
  float originalDuration, originalDelay;


  float[][] runTimes = new float[0][0]; // [0-conception time][1-start time][2-end time][3-startValue][4-endValue] -- chaing vars[5-original end time][6-new end time][7-new end time inception]
  float[] lastTime = new float[0]; // records the last time




  public float[] currentSplineType = EASE_IN_OUT;

  public KeySpline[] splines = new KeySpline[0]; 
  public KeySpline baseSpline = new KeySpline(currentSplineType[0], currentSplineType[1], currentSplineType[2], currentSplineType[3]);

  /*

   final int LINEAR = 0;
   final int QUAD_BOTH = 1;
   final int CUBIC_BOTH = 2;
   final int QUARTIC_BOTH = 3;
   final int QUINT_IN = 20;
   final int CUBIC_IN = 22;
   final int CUBIC_OUT = 23;
   int mode = CUBIC_BOTH; // default
   */


  STween (float duration_, float delay_, float startValue_, float endValue_) {
    currentValue = startValue_;
    startValue = startValue_;
    endValue = endValue_;

    //    conception = frameCount;
    duration = duration_;

    delay = delay_;
    lastFrame = frameCount;
    originalStartValue = startValue_;
    originalEndValue = endValue_;
    originalDuration = duration_;
    originalDelay = delay_;
  } // end constructor

  /*
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
   */

  public void setEaseLinear() {
    currentSplineType = EASE_LINEAR;
  } // end setEaseLinear
  public void setEaseInOut() {
    currentSplineType = EASE_IN_OUT;
  } // end setEaseInOut
  public void setEaseIn() {
    currentSplineType = EASE_IN;
  } // end setEaseIn
  public void setEaseOut() {
    currentSplineType = EASE_OUT;
  } // end setEaseOut
  public void setEase(float[] easeIn) {
    setEase(easeIn[0], easeIn[1], easeIn[2], easeIn[3]);
  } // end setEase
  public void setEase(float x1, float y1, float x2, float y2) {
    currentSplineType = new float[4];
    currentSplineType[0] = x1;
    currentSplineType[1] = y1;
    currentSplineType[2] = x2;
    currentSplineType[3] = y2;
  } // end setEase

  public float[] getEase() {
    return currentSplineType;
  } // end getEase


    void setTimeToFrames() {
    setTimeMode(FRAMES_MODE);
  } // end setTimeToFrames
  void setTimeToSeconds() {
    setTimeMode(SECONDS_MODE);
  } // end setTimeToSeconds
  void setTimeMode(int modeIn) {
    timeMode = modeIn;
  } // end setTimeMode  
  int getTimeMode() {
    return timeMode;
  } // end getTimeMode



    void setBegin(float startIn) {
    startValue = startIn;
  } // end setBegin

    void setEnd(float endIn) {
    endValue = endIn;
  } // end endIn

    void setDuration(float durationIn) {
    duration = durationIn;
  } // end setDuration

    void setDelay(float delayIn) {
    delay = delayIn;
  } // end setDelay

  float getBegin() {
    return startValue;
  } // end getBegin

  float getEnd () {
    println("in getEnd.  endValue as: " + endValue);
    return endValue;
  } // end getEnd

  float getCurrent() {
    return currentValue;
  } // end getCurrent

  float getDuration() {
    return duration;
  } // end getDuration

    float getDelay() {
    return delay;
  } // end getDelay

    void play() {
    isPlaying = true;
    hasStarted = true;
    isDone = false;
    lastFrame = frameCount - 1;
    currentValue = startValue;    
    resetSteps();
    calculateSteps();
  } // end play  

  void resume() {
    paused = false;
  } // end resume

    void pause() {
    if (isPlaying) {
      paused = true;
    }
  } // end pause

    void reset() {
    isPlaying = false;
    paused = false;
    isDone = false;
    setBegin(originalStartValue);
    setEnd(originalEndValue);
    setDuration(originalDuration);
    setDelay(originalDelay);
    currentValue = startValue;
    resetSteps();
    resetHasStarted();
  } // end reset

  boolean isPaused() {
    return paused;
  } // end isPaused

    void playLive(float endValueIn) {
    playLive(endValueIn, duration, 0);
  }
  void playLive (float endValueIn, float durationIn, float delayIn) {
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
    hasStarted = true;
    isDone = false;
  } // end playLive

    void resetSteps() {
    runTimes = new float[0][0];
    //lastStep = new float[0];
    lastTime = new float[0];

    splines = new KeySpline[0];
    //    lastRunTime = 0f;
  } 


  void calculateSteps() {
    float[] newRunTimes = new float[8];
    if (timeMode == FRAMES_MODE) {
      newRunTimes[0] = frameCount;
      newRunTimes[1] = delay + newRunTimes[0];
      newRunTimes[2] = newRunTimes[1] + duration;
    }
    else {
      newRunTimes[0] = millis();
      newRunTimes[1] = 1000 * (delay) + newRunTimes[0];
      newRunTimes[2] = newRunTimes[1] + 1000 * (duration);
    }

    newRunTimes[3] = startValue;
    newRunTimes[4] = endValue;
    runTimes = (float[][])append(runTimes, newRunTimes);
    lastTime = (float[])append(lastTime, 0f);
    splines = (KeySpline[])append(splines, baseSpline.get());
  } // end calculateSteps





  float value() {
    if (hasSteps()) {
      // deal with pauses...
      if (paused) {
        for (int i = 0; i < runTimes.length; i++) {
          if (frameCount != lastFrame) {
            if (timeMode == FRAMES_MODE) {
              runTimes[i][1]++;
              runTimes[i][2]++;
              lastTime[i] = frameCount;
            }
            else {
              float millisDiff = millis() - lastTime[i];
              runTimes[i][1] += millisDiff;
              runTimes[i][2] += millisDiff;
              lastTime[i] = millis();
            }
          }
        }
      } 
      else {
        float lastValue = 0;
        for (int i = 0; i < runTimes.length; i++) {
          if (frameCount != lastFrame) {
            if (i == 0) lastValue = runTimes[i][3];
            if (timeMode == FRAMES_MODE) {
              if (i == 0 && frameCount >= runTimes[i][2]) {
                lastValue = runTimes[i][4];
              } 

              // reset the start value based on the previous end value
              runTimes[i][3] = lastValue;
              if (frameCount <= runTimes[i][2] && frameCount >= runTimes[i][1]) {

                if (i == runTimes.length - 1) runTimes[i][4] = endValue;
                lastValue = getStep(runTimes[i], splines[i], frameCount);
              }
              else if (frameCount > runTimes[i][2]) {
                lastValue = runTimes[i][4];
                if (i == runTimes.length - 1 && frameCount >= runTimes[runTimes.length - 1][2]) {
                  lastValue = runTimes[i][4];
                  clearArrays();
                  break;
                }
              }
              else {
              }
            } 
            else {
              lastTime[i] = millis();
              if (i == 0 && millis() >= runTimes[i][2]) {
                lastValue = runTimes[i][4];
              }

              // reset the start value based on the previous end value
              runTimes[i][3] = lastValue;
              if (millis() <= runTimes[i][2] && millis() >= runTimes[i][1]) {
                if (i == runTimes.length - 1) runTimes[i][4] = endValue;       
                lastValue = getStep(runTimes[i], splines[i], millis());
              }
              else if (millis() > runTimes[i][2]) {
                lastValue = runTimes[i][4];
                if (i == runTimes.length - 1 && millis() >= runTimes[runTimes.length - 1][2]) {
                  lastValue = runTimes[i][4];
                  clearArrays();
                  break;
                }
              }
            }
            currentValue = lastValue;
          }
        }
      }
      if (frameCount != lastFrame) lastFrame = frameCount;
    }
    else { // does not have steps
      //isPlaying = false;
      if (hasStarted) {
        clearArrays();
      }
    } 

    // adjust the final value when the tween is done
    if (isDone) {
      currentValue = endValue;
    } 
    else if (!hasStarted && !isPlaying) {
      currentValue = startValue;
    }

    return currentValue;
  } // end value


    void clearArrays() {
    println(frameCount + " should stop");
    runTimes = new float[0][0];
    isPlaying = false;
    isDone = true;
  } // end clearArray

  boolean hasSteps() {
    if (timeMode == FRAMES_MODE) {
      for (float[] f : runTimes) if (frameCount <= f[2]) return true;
    } 
    else {
      for (float[] f : runTimes) if (millis() <= f[2]) return true;
    }
    return false;
  } // end hasSteps

  boolean isPlaying() {
    if (hasSteps() && isPlaying) return true;
    return false;
  } // end isPlaying

  boolean isDone() {
    return isDone;
  } // end isDone

    boolean hasStarted() {
    return hasStarted;
  } // end hasStarted

    void resetHasStarted() {
    hasStarted = false;
  } // end resetHasStarted

  float getStep(float[] runTimeIn, KeySpline splineIn, float timeIn) {
    float thisStartValue = runTimeIn[3];
    float thisEndValue = runTimeIn[4];
    float diff = thisEndValue - thisStartValue;
    float startTime = runTimeIn[1];
    float endTime = runTimeIn[2];
    float percentOfTime = (float)(timeIn - startTime) / (endTime - startTime);
    float splineValue = splineIn.findValue(percentOfTime);
    return (splineValue * diff + thisStartValue);
  } // end getStep
} // end class STween

