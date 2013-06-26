package simpleTween;

public class MSTween {
	private STweenManager st;
	private String methodName;
	private Object targetObj;

	public MSTween(float durationDelay_, String methodName_, Object targetObj_) {
		st = new STweenManager(1);
		methodName = methodName_;
		targetObj = targetObj_;
		float[] start = { 0 };
		float[] end = { 1 };
		st.setInitialTweens(durationDelay_, 0, start, end);
	} // end constructor

	public void setTimeToFrames() {
		st.setTimeToFrames();
	} // end setTimeToFrames

	public void setTimeToSeconds() {
		st.setTimeToSeconds();
	} // end setTimeToSeconds

	public int getTimeMode() {
		return st.getTimeMode();
	} // end getTimeMode

	public void play() {
		if (!st.isPlaying())
			st.onEnd(targetObj, methodName);
		st.play();
	} // end play
} // end class BSTween
