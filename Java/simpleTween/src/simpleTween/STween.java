package simpleTween;

public class STween {
	private float duration = 0;
	private float delay = 0;
	private float lastFrame = 0;

	public int timeMode = SimpleTween.baseTimeMode;

	private boolean isPlaying = false;
	private boolean hasStarted = false;
	private boolean paused = false;
	private boolean isDone = false;

	private float currentValue = 0f;
	private float startValue, endValue;
	private float originalStartValue, originalEndValue;
	private float originalDuration, originalDelay;

	private float[][] runTimes = new float[0][0]; // [0-conception time][1-start
													// time][2-end
													// time][3-startValue][4-endValue]
													// -- chaing vars[5-original
													// end time][6-new end
													// time][7-new end time
													// inception]
	private float[] lastTime = new float[0]; // records the last time

	public int mode = SimpleTween.baseEasingMode; // default

	public STween(float duration_, float delay_, float startValue_,
			float endValue_) {
		currentValue = startValue_;
		startValue = startValue_;
		endValue = endValue_;
		duration = duration_;
		delay = delay_;
		lastFrame = SimpleTween.parent.frameCount;
		originalStartValue = startValue_;
		originalEndValue = endValue_;
		originalDuration = duration_;
		originalDelay = delay_;
	} // end constructor

	public void setModeLinear() {
		mode = SimpleTween.LINEAR;
	} // end setModeLinear

	public void setModeCubicBoth() {
		mode = SimpleTween.CUBIC_BOTH;
	} // end setModeCubic

	public void setModeCubicIn() {
		mode = SimpleTween.CUBIC_IN;
	} // end setModeCubicIn

	public void setModeCubicOut() {
		mode = SimpleTween.CUBIC_OUT;
	} // end setModeCubicOut

	public void setModeQuadBoth() {
		mode = SimpleTween.QUAD_BOTH;
	} // end setModeQuadBot

	public void setModeQuarticBoth() {
		mode = SimpleTween.QUARTIC_BOTH;
	} // end setModeQuarticBoth

	public void setModeQuintIn() {
		mode = SimpleTween.QUINT_IN;
	} // end setModeQuintIn

	public void setMode(int modeIn) {
		mode = modeIn;
	} // end setMode

	public void setTimeToFrames() {
		setTimeMode(SimpleTween.FRAMES_MODE);
	} // end setTimeToFrames

	public void setTimeToSeconds() {
		setTimeMode(SimpleTween.SECONDS_MODE);
	} // end setTimeToSeconds

	public void setTimeMode(int modeIn) {
		timeMode = modeIn;
	} // end setTimeMode

	public int getTimeMode() {
		return timeMode;
	} // end getTimeMode

	public void setBegin(float startIn) {
		startValue = startIn;
	} // end setBegin

	public void setEnd(float endIn) {
		endValue = endIn;
	} // end endIn

	public void setDuration(float durationIn) {
		duration = durationIn;
	} // end setDuration

	public void setDelay(float delayIn) {
		delay = delayIn;
	} // end setDelay

	public float getDuration() {
		return duration;
	} // end getDuration

	public float getDelay() {
		return delay;
	} // end getDelay

	public float getBegin() {
		return startValue;
	} // end getBegin

	public float getEnd() {
		return endValue;
	} // end getEnd

	public float getCurrent() {
		return currentValue;
	} // end getCurrent

	public void play() {
		if (isPlaying && paused) {
			paused = false;
		} else {
			isPlaying = true;
			hasStarted = true;
			isDone = false;
			lastFrame = SimpleTween.parent.frameCount - 1;
			currentValue = startValue;
			resetSteps();
			calculateSteps();
		}
	} // end play

	public void pause() {
		if (isPlaying)
			paused = true;
	} // end pause

	public void resume() {
		paused = false;
	} // end resume

	public void reset() {
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

	public boolean isPaused() {
		return paused;
	} // end isPaused

	public void playLive(float endValueIn) {
		playLive(endValueIn, duration, 0);
	}

	public void playLive(float endValueIn, float durationIn, float delayIn) {
		if (isPlaying) {
			startValue = endValue;
		} else {
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

	public void resetSteps() {
		runTimes = new float[0][0];
	}

	public void calculateSteps() {
		float[] newRunTimes = new float[8];
		if (timeMode == SimpleTween.FRAMES_MODE) {
			newRunTimes[0] = SimpleTween.parent.frameCount;
			newRunTimes[1] = delay + newRunTimes[0];
			newRunTimes[2] = newRunTimes[1] + duration;
		} else {
			newRunTimes[0] = SimpleTween.parent.millis();
			newRunTimes[1] = 1000 * (delay) + newRunTimes[0];
			newRunTimes[2] = newRunTimes[1] + 1000 * (duration);
		}
		newRunTimes[3] = startValue;
		newRunTimes[4] = endValue;

		runTimes = SimpleTween.append(runTimes, newRunTimes);
		lastTime = SimpleTween.append(lastTime, 0f);
	} // end calculateSteps

	public float value() {
		if (hasSteps()) {
			// check the global pause if any
			if (SimpleTween.globalSTpaused && !isPaused()) {
				pause();
			}
			else if (!SimpleTween.globalSTpaused && isPaused()) {
				resume();
			}
			
			
			// deal with pauses...
			if (paused) {
				for (int i = 0; i < runTimes.length; i++) {
					if (SimpleTween.parent.frameCount != lastFrame) {
						if (timeMode == SimpleTween.FRAMES_MODE) {
							runTimes[i][1]++;
							runTimes[i][2]++;
							lastTime[i] = SimpleTween.parent.frameCount;
						} else {
							float millisDiff = SimpleTween.parent.millis()
									- lastTime[i];
							runTimes[i][1] += millisDiff;
							runTimes[i][2] += millisDiff;
							lastTime[i] = SimpleTween.parent.millis();
						}

					}
				}
			} else {
				float lastValue = 0;
				for (int i = 0; i < runTimes.length; i++) {
					if (SimpleTween.parent.frameCount != lastFrame) {
						if (i == 0)
							lastValue = runTimes[i][3];
						if (timeMode == SimpleTween.FRAMES_MODE) {
							if (i == 0
									&& SimpleTween.parent.frameCount >= runTimes[i][2]) {
								lastValue = runTimes[i][4];
							}

							// reset the start value based on the previous end
							// value
							runTimes[i][3] = lastValue;
							if (SimpleTween.parent.frameCount <= runTimes[i][2]
									&& SimpleTween.parent.frameCount >= runTimes[i][1]) {
								lastValue = getStep(runTimes[i]);
							} else if (SimpleTween.parent.frameCount > runTimes[i][2]) {
								lastValue = runTimes[i][4];
								if (i == runTimes.length - 1
										&& SimpleTween.parent.frameCount >= runTimes[runTimes.length - 1][2]) {
									lastValue = runTimes[i][4];
									clearArrays();
									break;
								}
							} else {
							}
						} else {
							lastTime[i] = SimpleTween.parent.millis();
							if (i == 0
									&& SimpleTween.parent.millis() >= runTimes[i][2]) {
								lastValue = runTimes[i][4];
							}

							// reset the start value based on the previous end
							// value
							runTimes[i][3] = lastValue;
							if (SimpleTween.parent.millis() <= runTimes[i][2]
									&& SimpleTween.parent.millis() >= runTimes[i][1]) {
								lastValue = getStep(runTimes[i]);
							} else if (SimpleTween.parent.millis() > runTimes[i][2]) {
								lastValue = runTimes[i][4];
								if (i == runTimes.length - 1
										&& SimpleTween.parent.millis() >= runTimes[runTimes.length - 1][2]) {
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
			if (SimpleTween.parent.frameCount != lastFrame)
				lastFrame = SimpleTween.parent.frameCount;
			
		} else { // does not have steps
			// isPlaying = false;
			if (hasStarted) {
				clearArrays();
			}
		}

		// adjust the final value when the tween is done
		if (isDone) {
			currentValue = endValue;
		} else if (!hasStarted && !isPlaying) {
			currentValue = startValue;
		}

		
		return currentValue;
	} // end value

	public void clearArrays() {
		runTimes = new float[0][0];
		isPlaying = false;
		isDone = true;
	} // end clearArray

	public boolean hasSteps() {
		if (timeMode == SimpleTween.FRAMES_MODE) {
			for (float[] f : runTimes)
				if (SimpleTween.parent.frameCount <= f[2])
					return true;
		} else {
			for (float[] f : runTimes)
				if (SimpleTween.parent.millis() <= f[2])
					return true;
		}
		return false;
	} // end hasSteps

	public boolean isPlaying() {
		if (hasSteps() && isPlaying)
			return true;
		return false;
	} // end isPlaying

	public boolean isDone() {
		if (!hasSteps() && runTimes.length > 0)
			return true;
		return false;
	} // end isDone

	public boolean hasStarted() {
		return hasStarted;
	} // end hasStarted

	public void resetHasStarted() {
		hasStarted = false;
	} // end resetHasStarted

	public float getStep(float[] runTimeIn) {
		float thisStep = 0f;
		// see http://www.gizma.com/easing/
		// t = current time -- SimpleTween.parent.frameCount - conception
		// b = start value -- startValue
		// c = change in value -- (endValue - startValue)
		// d = duration -- duration
		float t = SimpleTween.parent.frameCount - runTimeIn[1];
		if (timeMode == SimpleTween.SECONDS_MODE)
			t = SimpleTween.parent.millis() - runTimeIn[1];
		float c = runTimeIn[4] - runTimeIn[3];
		float d = runTimeIn[2] - runTimeIn[1];
		float b = runTimeIn[3];
		// float b = 0f;
		switch (mode) {
		case SimpleTween.LINEAR:
			thisStep = c * t / d + b;
			break;
		case SimpleTween.QUAD_BOTH:
			t /= d / 2;
			if (t < 1)
				thisStep = c / 2 * t * t + b;
			else {
				t--;
				thisStep = -c / 2 * (t * (t - 2) - 1) + b;
			}
			break;
		case SimpleTween.CUBIC_BOTH:
			t /= d / 2;
			if (t < 1)
				thisStep = c / 2 * t * t * t + b;
			else {
				t -= 2;
				thisStep = c / 2 * (t * t * t + 2) + b;
			}
			break;
		case SimpleTween.CUBIC_IN:
			t /= d;
			thisStep = c * t * t * t + b;
			break;
		case SimpleTween.CUBIC_OUT:
			t /= d;
			t--;
			thisStep = c * (t * t * t + 1) + b;
			break;
		case SimpleTween.QUARTIC_BOTH:
			t /= d / 2;
			if (t < 1)
				thisStep = c / 2 * t * t * t * t + b;
			else {
				t -= 2;
				thisStep = -c / 2 * (t * t * t * t - 2) + b;
			}
			break;
		case SimpleTween.QUINT_IN:
			t /= d;
			thisStep = c * t * t * t * t * t + b;
			break;
		} // end switch
		return thisStep;
	} // end getStep
} // end class FST
