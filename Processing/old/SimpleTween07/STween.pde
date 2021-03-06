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
  


  float currentValue = 0f;
  float startValue, endValue;
  float originalStartValue, originalEndValue;
  float originalDuration, originalDelay;


  // ********** //
  float[][] runTimes = new float[0][0]; // [0-conception time][1-start time][2-end time][3-startValue][4-endValue] -- chaing vars[5-original end time][6-new end time][7-new end time inception]
  float[] lastStep = new float[0]; // records last step for this runtime
  float[] lastTime = new float[0]; // records the last time


  /******/
  float lastRunTime = 0f; // the most recent play or playLive will set this.  any other playLives will lerp back to hit this time
  float lastRunTimeInception = 0; // frame or time when this last run time was established



  final int LINEAR = 0;
  final int QUAD_BOTH = 1;
  final int CUBIC_BOTH = 2;
  final int QUARTIC_BOTH = 3;
  final int QUINT_IN = 20;
  final int CUBIC_IN = 22;
  final int CUBIC_OUT = 23;
  int mode = CUBIC_BOTH; // default

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

  /*
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
   */

  void play() {
    isPlaying = true;
    hasStarted = true;
    lastFrame = frameCount - 1;
    currentValue = startValue;    
    resetSteps();
    calculateSteps();

  } // end play  


  // ************* //
  void resume() {
    paused = false;
  } // end resume


    void pause() {
    if (isPlaying) paused = true;
  } // end pause

    void reset() {
    isPlaying = false;
    paused = false;
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
    
    println("IN PLAYLIVE.  ENDVALUE AS : "  + endValueIn);
    
    endValue = endValueIn;
    duration = durationIn;
    delay = delayIn;
    calculateSteps();
    isPlaying = true;
    paused = false;
    hasStarted = true;
    //}
  } // end playLive

    void resetSteps() {
    runTimes = new float[0][0];
    lastStep = new float[0];
    lastTime = new float[0];
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

    newRunTimes[5] = newRunTimes[2];
    newRunTimes[6] = newRunTimes[2];
    newRunTimes[7] = newRunTimes[0];
    lastRunTimeInception = newRunTimes[0];
    lastRunTime = newRunTimes[2];


    newRunTimes[3] = startValue;
    newRunTimes[4] = endValue;
    runTimes = (float[][])append(runTimes, newRunTimes);
    lastStep = (float[])append(lastStep, 0f);
    lastTime = (float[])append(lastTime, 0f);
  } // end calculateSteps


  void adjustDurations() {
      for (int i = 0; i < runTimes.length; i++) {
        if (lastRunTime < runTimes[i][6]) {
          runTimes[i][5] = runTimes[i][6];
          runTimes[i][6] = lastRunTime;
          runTimes[i][7] = lastRunTimeInception;
        }
      }
    
    // / [0-conception time][1-start time][2-end time][3-startValue][4-endValue] -- chaing vars[5-original end time][6-new end time][7-new end time inception]
    /*
            if (runTimes[i][6] < runTimes[i][5]) {
     if (timeMode == FRAMES_MODE) runTimes[i][2] = constrain(map(frameCount, runTimes[i][7], lastRunTime, runTimes[i][5], runTimes[i][6]), runTimes[i][6], runTimes[i][5]);
     else runTimes[i][2] = constrain(map(millis(), runTimes[i][7], lastRunTime, runTimes[i][5], runTimes[i][6]), runTimes[i][6], runTimes[i][5]);
     } 
     */

    // adjust the runTimes[i][2] if the most recent one is shorter
  } // ene adjustDurations



  float value() {
    if (hasSteps()) {
      // deal with pauses...
      if (paused) {
        for (int i = 0; i < runTimes.length; i++) {
          if (frameCount != lastFrame) {
            if (timeMode == FRAMES_MODE) {
              runTimes[i][1]++;
              runTimes[i][2]++;
              runTimes[i][5]++;
              runTimes[i][6]++;
              runTimes[i][7]++;

              // ******** // 
              lastRunTimeInception++;
              lastTime[i] = frameCount;
            }
            else {
              float millisDiff = millis() - lastTime[i];
              runTimes[i][1] += millisDiff;
              runTimes[i][2] += millisDiff;
              runTimes[i][5] += millisDiff;
              runTimes[i][6] += millisDiff;
              runTimes[i][7] += millisDiff;
              lastTime[i] = millis();

              // ************************ // 
              lastRunTimeInception+= millisDiff;
            }
          }
        }
      } 
      else {
        for (int i = 0; i < runTimes.length; i++) {
          if (frameCount != lastFrame) {

            // ***************************************** //  
            if (runTimes[i][6] < runTimes[i][5]) {
              if (timeMode == FRAMES_MODE) runTimes[i][2] = constrain(map(frameCount, runTimes[i][7], runTimes[i][6], runTimes[i][5], runTimes[i][6]), runTimes[i][6], runTimes[i][5]);
              else runTimes[i][2] = constrain(map(millis(), runTimes[i][7], runTimes[i][6], runTimes[i][5], runTimes[i][6]), runTimes[i][6], runTimes[i][5]);
            } 



            if (timeMode == FRAMES_MODE) {
              if (frameCount <= runTimes[i][2] && frameCount >= runTimes[i][1]) { 
                float newStepSize = getStep(runTimes[i]);
                float adjustedStep = newStepSize - lastStep[i]; 
                currentValue += adjustedStep;
                lastStep[i] = newStepSize;
              }
            }
            else {
              if (millis() <= runTimes[i][2] && millis() >= runTimes[i][1]) {
                float newStepSize = getStep(runTimes[i]);
                float adjustedStep = newStepSize - lastStep[i]; 
                currentValue += adjustedStep;
                lastStep[i] = newStepSize;
              }
            }
          }
        }
      }

      // record the last times
      for (int i = 0; i < runTimes.length; i++) {
        if (frameCount != lastFrame) {
          if (timeMode == FRAMES_MODE) {
            lastTime[i] = frameCount;
          }
          else {

            lastTime[i] = millis();
          }
        }
      }
      if (frameCount != lastFrame) lastFrame = frameCount;
    }


    else {
      isPlaying = false;
    } 

    // adjust the final value when the tween is done
    if (isDone()) {
      currentValue = endValue;
    } 
    else if (!hasStarted && !isPlaying) {
      currentValue = startValue;
    }




    return currentValue;
  } // end value










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
    if (!hasSteps() && runTimes.length > 0) return true;
    return false;
  } // end isDone

    boolean hasStarted() {
    return hasStarted;
  } // end hasStarted

    void resetHasStarted() {
    hasStarted = false;
  } // end resetHasStarted

  float getDuration() {
    return duration;
  } // end getDuration

    float getDelay() {
    return delay;
  } // end getDelay

    float getStep(float[] runTimeIn) {
    float thisStep = 0f;
    // see http://www.gizma.com/easing/
    // t = current time -- frameCount - conception
    // b = start value -- startValue
    // c = change in value -- (endValue - startValue)
    // d = duration -- duration
    float t = frameCount - runTimeIn[1];
    if (timeMode == SECONDS_MODE) t = millis() - runTimeIn[1];
    float c = runTimeIn[4] - runTimeIn[3];
    float d = runTimeIn[2] - runTimeIn[1];
    //float b = runTimeIn[3];
    float b = 0f;
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
} // end class STween

