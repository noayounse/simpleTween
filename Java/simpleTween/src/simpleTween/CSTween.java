package simpleTween;

// Color SimpleTween
public class CSTween extends STweenManager {

	public CSTween(float duration_, float delay_, int startColor_, int endColor_) {
		super(4); // 4 for colors - rgba
		setInitialTweens(duration_, delay_, breakUp(startColor_),
				breakUp(endColor_));
	} // end constructor

	public void setCurrent(int valueIn) {
		float[] brokenValues = breakUp(valueIn);
		super.setCurrent(brokenValues);
	} // end setCurrent

	public void setBegin(int valueIn) {
		float[] brokenValues = breakUp(valueIn);
		super.setBegin(brokenValues);
	} // end setBegin

	public void setEnd(int valueIn) {
		float[] brokenValues = breakUp(valueIn);
		super.setEnd(brokenValues);
	} // end setEnd

	public int getBegin() {
		float[] broken = super.getBrokenBegin();
		return compose(broken);
	} // end getBegin

	public int getEnd() {
		float[] broken = super.getBrokenEnd();
		return compose(broken);
	} // end getEnd

	public void playLive(int valueIn) {
		STween lastTween = super.allTweens.get(allTweens.size() - 1);
		playLive(valueIn, lastTween.getDuration(), 0);
	} // end playLive

	public void playLive(int valueIn, float durationIn, float delayIn) {
		super.playLive(breakUp(valueIn), durationIn, delayIn);
	} // end playLive

	/*
	 * does not work yet
	 * 
	 * public void jitter(int valueIn) { STween lastTween =
	 * super.allTweens.get(0); jitter(valueIn, lastTween.getDuration() / 4f, 0);
	 * } // end jitter
	 * 
	 * public void jitter(int valueIn, float durationIn, float delayIn) {
	 * super.jitter(breakUp(valueIn), durationIn, delayIn); } // end jitter
	 */

	public int value() {
		float[] broken = super.valueFloatArray();
		return compose(broken);
	} // end valuePVector

	private float[] breakUp(int in) {
		float[] broken = new float[4];
		broken[0] = (in >> 24) & 0xFF;
		broken[1] = (in >> 16) & 0xFF;
		broken[2] = (in >> 8) & 0xFF;
		broken[3] = (in >> 0) & 0xFF;
		return broken;
	} // end breakUp

	private int compose(float[] floatsIn) {
		int redone = (int) floatsIn[0];
		redone = (int) ((redone << 8) + SimpleTween.constrain(floatsIn[1], 0, 255));
		redone = (int) ((redone << 8) + SimpleTween.constrain(floatsIn[2], 0, 255));
		redone = (int) ((redone << 8) + SimpleTween.constrain(floatsIn[3], 0, 255));
		return redone;
	} // end compose

	public void addNextTarget(int valueIn) {
		addNextTarget(super.getDuration(), super.getDelay(), valueIn,
				super.getTimeMode());
	} // end addNextTarget

	public void addNextTarget(int valueIn, int timeModeIn) {
		addNextTarget(super.getDuration(), super.getDelay(), valueIn,
				timeModeIn);
	} // end addNextTarget

	public void addNextTarget(float durationIn, float delayIn, int valueIn,
			int timeModeIn) {
		super.addNextTarget(durationIn, delayIn, breakUp(valueIn), timeModeIn);
	} // end addNextTarget
} // end class PVSTween
