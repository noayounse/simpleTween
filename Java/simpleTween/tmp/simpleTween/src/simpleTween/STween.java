package simpleTween;

import java.util.ArrayList;

public class STween {
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
	public boolean inRedirect = false;
	private float redirectNewTarget = 0f;
	private float redirectOldTarget = 0f;
	private int redirectNewDuration = 0;
	private int redirectOldDuration = 0;
	private int lastRedirectDuration = 0;

	// targets
	public ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

	public STween(int duration_, int delay_) {
		duration = duration_;
		redirectOldDuration = duration; // like a backup
		delay = delay_;
		value = startValue;
	} // end Constructor

	public void setModeLinear() {
		mode = LINEAR;
	} // end setModeLinear

	public void setModeCubicBoth() {
		mode = CUBIC_BOTH;
	} // end setModeCubic

	public void setModeQuadBoth() {
		mode = QUAD_BOTH;
	} // end setModeQuadBot

	public void setModeQuarticBoth() {
		mode = QUARTIC_BOTH;
	} // end setModeQuarticBoth

	public void setModeQuintIn() {
		mode = QUINT_IN;
	} // end setModeQuintIn

	public void play() {
		if (!isPlaying && progress > 0)
			conception -= delay;
		else if (!isPlaying)
			conception = SimpleTween.parent.frameCount;
		if (progress == duration || isPlaying)
			progress = 0;
		if (redirectTween != null)
			redirectTween.play();
		isPlaying = true;
	} // end play

	public void pause() {
		isPlaying = false;
		if (redirectTween != null)
			redirectTween.pause();
	} // end

	public boolean isPlaying() {
		return isPlaying;
	} // end isPlaying

	public void setBegin(float valueIn) {
		resetProgress();
		startValue = valueIn;
	} // end setBegin

	public void setEnd(float valueIn) {
		setBegin(value);
		endValue = valueIn;
	} // end setEnd

	public void addNextTarget(Object valueIn) {
		addNextTarget(valueIn, redirectOldDuration, delay);
	} // end addNextTarget

	public void addNextTarget(Object valueIn, int durationIn, int delayIn) {
		NextTarget newTarget = new NextTarget(valueIn, durationIn, delayIn);
		nextTargets.add(newTarget);
	} // end addNextTarget

	public void resetProgress() {
		progress = 0;
	} // end resetProgress

	public void setDelay(int delayIn) {
		if (!isPlaying()) {
			delay = delayIn;
		}
	} // end setDelay

	public void setDuration(int durationIn) {
		duration = durationIn;
	} // end setDuration

	public int getDuration() {
		return duration;
	} // end getDuration

	public int getProgress() {
		return progress;
	} // end getProgress

	public boolean isDone() {
		if ((progress >= duration && redirectTween == null))
			return true;
		return false;
	} // end isDone

	public float valueST() {
		updateRedirect();
		if (isPlaying && progress >= duration && redirectTween == null) {
			// println(frameCount + " toggling isPlaying to false");
			isPlaying = false;
		}
		if (isPlaying && SimpleTween.parent.frameCount > conception + delay) {
			if (SimpleTween.parent.frameCount != lastFrame) {
				progress++;
				lastFrame = SimpleTween.parent.frameCount;
			}
			findValue();
		} else if (progress >= duration && redirectTween == null) {
			value = endValue;
		} else if (progress == 0) {
			value = startValue;
		}
		updatePercent();
		return value;
	}// end value

	private void updatePercent() {
		percent = (float) progress / duration;
	} // end updateMultiplierAndPercent

	private void findValue() {
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
		case LINEAR:
			value = c * t / d + b;
			break;
		case QUAD_BOTH:
			t /= d / 2;
			if (t < 1)
				value = c / 2 * t * t + b;
			else {
				t--;
				value = -c / 2 * (t * (t - 2) - 1) + b;
			}
			break;
		case CUBIC_BOTH:
			t /= d / 2;
			if (t < 1)
				value = c / 2 * t * t * t + b;
			else {
				t -= 2;
				value = c / 2 * (t * t * t + 2) + b;
			}
			break;
		case QUARTIC_BOTH:
			t /= d / 2;
			if (t < 1)
				value = c / 2 * t * t * t * t + b;
			else {
				t -= 2;
				value = -c / 2 * (t * t * t * t - 2) + b;
			}
			break;
		case QUINT_IN:
			t /= d;
			value = c * t * t * t * t * t + b;
			break;
		} // end switch
	} // end findValue

	public void redirect() {
		//if (isPlaying && redirectTween == null) { // for now only one redirect
													// is allowed because more
													// than one looks crappy
		if (isPlaying) { 
			// redirectTween = new STween(duration - progress - 1, 0, 0, 1);
			redirectNewTarget = 1f;
			redirectOldTarget = endValue;
			
			redirectTween = new STween(duration, 0);
			//redirectTween.mode = mode;
			redirectTween.mode = LINEAR;
			redirectTween.play();
			
			redirectNewDuration = (int) (Math.floor((duration - (conception
					+ duration - redirectTween.conception))));
			lastRedirectDuration = duration;
			if (!inRedirect) redirectOldDuration = duration;
			inRedirect = true;
		}
	} // end redirect

	private void updateRedirect() {
		if (inRedirect) {
			if (redirectTween.isDone() && progress >= duration) {
				endValue = redirectNewTarget;
				// System.out.println("resetting old duration: " + duration);
				duration = redirectOldDuration;
				// System.out.println("resetting old duration: " + duration);
				inRedirect = false;
				redirectTween = null;
			} else {
				endValue = (redirectTween.valueST() * redirectNewTarget + (1 - redirectTween
						.valueST()) * redirectOldTarget);
				duration = lastRedirectDuration + (int) (Math.floor(redirectTween.valueST()	* redirectOldDuration));
			}
		}
	} // end updateRedirect

	@Override
	public String toString() {
		return SimpleTween.parent.frameCount + " duration: " + duration
				+ " start: " + startValue + " end: " + endValue
				+ " isPlaying: " + isPlaying + " value: " + value
				+ " conception: " + conception + " delay: " + delay;
	} // end toString
} // end class SimpleTween
