package simpleTween;

public class NextTarget {
	private Object nextTarget;
	private int duration = 1;
	private int delay = 0;

	public NextTarget(Object nextTarget_, int duration_, int delay_) {
		nextTarget = nextTarget_;
		duration = duration_;
		delay = delay_;
	} // end constructor

	public Object getTarget() {
		return nextTarget;
	} // end getTarget

	public int getDuration() {
		return duration;
	}// end getDuration

	public int getDelay() {
		return delay;
	} // end getDelay
} // end NextTarget
