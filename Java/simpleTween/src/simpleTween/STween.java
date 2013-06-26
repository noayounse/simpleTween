package simpleTween;

public class STween {
	private float duration = 0;
	private float delay = 0;
	private float lastFrame = 0;

	public int timeMode = SimpleTween.baseTimeMode;

	private boolean isPlaying = false;
	private boolean hasStarted = false;
	private boolean paused = false;

	private float currentValue = 0f;
	private float startValue, endValue;
	private float originalStartValue, originalEndValue;
	private float originalDuration, originalDelay;

	private float[][] runTimes = new float[0][0]; // [conception time][start
													// time][end
													// time][startValue][endValue]
	private float[] lastStep = new float[0]; // records last step for this
												// runtime
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

	public void reset() {
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

	public boolean isPaused() {
		return paused;
	} // end isPaused

	public void playLive(float endValueIn) {
		playLive(endValueIn, duration, 0);
	}

	public void playLive(float endValueIn, float durationIn, float delayIn) {
		if (endValueIn != endValue) {
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
		}
	} // end playLive

	public void resetSteps() {
		runTimes = new float[0][0];
		lastStep = new float[0];
	}

	public void calculateSteps() {
		float[] newRunTimes = new float[5];
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
		lastStep = SimpleTween.append(lastStep, 0f);
		lastTime = SimpleTween.append(lastStep, 0f);
	} // end calculateSteps

	public float value() {
		if (hasSteps()) {
			// deal with pauses...
			if (paused) {
				for (int i = 0; i < runTimes.length; i++) {
					if (SimpleTween.parent.frameCount != lastFrame) {
						if (timeMode == SimpleTween.FRAMES_MODE) {
							runTimes[i][1]++;
							runTimes[i][2]++;
						} else {
							float millisDiff = SimpleTween.parent.millis() - lastTime[i];
							runTimes[i][1] += millisDiff;
							runTimes[i][2] += millisDiff;
							lastTime[i] = SimpleTween.parent.millis();
						}
					}
				}
			} else {
				for (int i = 0; i < runTimes.length; i++) {
					if (SimpleTween.parent.frameCount != lastFrame) {
						if (timeMode == SimpleTween.FRAMES_MODE) {
							if (SimpleTween.parent.frameCount <= runTimes[i][2]
									&& SimpleTween.parent.frameCount >= runTimes[i][1]) {
								float newStepSize = getStep(runTimes[i]);
								float adjustedStep = newStepSize - lastStep[i];
								currentValue += adjustedStep;
								lastStep[i] = newStepSize;
							}
						} else {
							if (SimpleTween.parent.millis() <= runTimes[i][2]
									&& SimpleTween.parent.millis() >= runTimes[i][1]) {
								float newStepSize = getStep(runTimes[i]);
								float adjustedStep = newStepSize - lastStep[i];
								currentValue += adjustedStep;
								lastStep[i] = newStepSize;
							}
						}
					}
				}
			}
			if (SimpleTween.parent.frameCount != lastFrame)
				lastFrame = SimpleTween.parent.frameCount;
		} else {
			isPlaying = false;
		}

		// adjust the final value when the tween is done
		if (isDone()) {
			currentValue = endValue;
		}
		else if(!hasStarted && !isPlaying) {
			currentValue = startValue;	
		}

		return currentValue;
	} // end value

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

	public float getDuration() {
		return duration;
	} // end getDuration

	public float getDelay() {
		return delay;
	} // end getDelay

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
		// float b = runTimeIn[3];
		float b = 0f;
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
