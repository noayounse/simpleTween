package simpleTween;

public class NextTarget {
	private float[] nextTarget;
	private float duration = 1;
	private float delay = 0;
	public int timeMode = 0;

	public NextTarget(float duration_, float delay_, float[] nextTarget_,
			int timeMode_) {
		nextTarget = nextTarget_;
		duration = duration_;
		delay = delay_;
		timeMode = timeMode_;
	} // end constructor

	public float[] getTarget() {
		return nextTarget;
	} // end getTarget

	public float getDuration() {
		return duration;
	}// end getDuration

	public float getDelay() {
		return delay;
	} // end getDelay
} // end NextTarget
