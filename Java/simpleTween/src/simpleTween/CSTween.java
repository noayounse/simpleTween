package simpleTween;

public class CSTween extends STween {
	private int startColor, endColor;
	private int valueC;

	// redirect vars
	private int redirectNewTargetC;
	private int redirectOldTargetC;

	public CSTween(int duration_, int delay_, int startColor_, int endColor_) {
		super(duration_, delay_);
		startColor = startColor_;
		endColor = endColor_;
		valueC = startColor;

		System.out.println("succesfully made a CSTween.");
		System.out.println("starting color as: " + startColor_);
		System.out.println("ending color as: " + endColor_);
	} // end constructor

	public int test() {
		System.out.println("startingColor: " + startColor);
		int tempAlpha = (startColor >> 24) & 0xFF;
		int tempRed = (startColor >> 16) & 0xFF;
		int tempGreen = (startColor >> 8) & 0xFF;
		int tempBlue = (startColor) & 0xFF;

		System.out.println("tempAlpha: " + tempAlpha + " tempRed: " + tempRed
				+ " tempGreen: " + tempGreen + " tempBlue: " + tempBlue + " super.valueST(): " + super.valueST());
		int redone = tempAlpha;
		redone = (redone << 8) + tempRed;
		redone = (redone << 8) + tempGreen;
		redone = (redone << 8) + tempBlue;
		System.out.println("redone: " + redone);
		return redone;
	} // end temp

	public void playLive(int valueIn) {
		if (valueIn - endColor != 0
				|| (!super.isPlaying() && startColor != endColor)) {
			if (super.isPlaying() && !super.inRedirect) {
				redirect(valueIn);
			} else if (!super.isPlaying() && !super.inRedirect) {
				setBegin(valueC);
				setEnd(valueIn);
				super.play();
			} else
				return;
		}
	} // end playLive

	public void setBegin(int valueIn) {
		startColor = valueIn;
	} // end setBegin

	public void setEnd(int valueIn) {
		setBegin(valueC);
		super.setBegin(0);
		endColor = valueIn;
	} // end setEnd

	public int getBegin() {
		return startColor;
	} // end getBegin

	public int getEnd() {
		return endColor;
	} // end getEnd

	private int red (int colorIn) {
		return (colorIn >> 16) & 0xFF;
	} // end red
	
	private int green (int colorIn) {
		return (colorIn >> 8) & 0xFF;
	} // end green
	
	private int blue (int colorIn) {
		return (colorIn) & 0xFF;
	} // end blue
	
	private int alpha (int colorIn) {
		return (colorIn >> 24) & 0xFF;		
	} // end alpha
	
	private int makeColor(float r, float g, float b, float a) {
		return makeColor((int)r, (int)g, (int)b, (int)a);
	} // end makeColor from floats
	private int makeColor(int r, int g, int b, int a) {
		int newColor = a;
		newColor = (newColor << 8) + r;
		newColor = (newColor << 8) + g;
		newColor = (newColor << 8) + b;	
		return newColor;
	} // end make Color
	
	public int value() {
		updateRedirectC();
		float multiplier = super.valueST();
		if (multiplier == 1)
			valueC = endColor;
		else if (multiplier == 0)
			valueC = startColor;
		else {
			float r = (multiplier * red(endColor) + (1f - multiplier)
					* red(startColor));
			float g = (multiplier * green(endColor) + (1f - multiplier)
					* green(startColor));
			float b = (multiplier * blue(endColor) + (1f - multiplier)
					* blue(startColor));
			float a = (multiplier * alpha(endColor) + (1f - multiplier)
					* alpha(startColor));
			valueC = makeColor(r, g, b, a);
		}
		// look for and assign any nextTargets
		if (!super.isPlaying() && super.isDone()
				&& super.nextTargets.size() > 0) {
			NextTarget nextTarget = super.nextTargets.get(0);
			super.nextTargets.remove(0);
			super.setDuration(nextTarget.getDuration());
			super.setDelay(nextTarget.getDelay());
			setEnd((Integer) nextTarget.getTarget());
			super.play();
		}
		return valueC;
	} // end value

	private void redirect(int c) {
		if (super.isPlaying && super.redirectTween == null) {
			super.redirect();
			redirectNewTargetC = c;
			redirectOldTargetC = endColor;
		}
	} // end redirect

	private void updateRedirectC() {
		if (super.inRedirect) {
			if (super.redirectTween.isDone()) {
				endColor = redirectNewTargetC;
			} else {
				float r = (super.redirectTween.valueST()
						* red(redirectNewTargetC) + (1 - super.redirectTween
						.valueST()) * red(redirectOldTargetC));
				float g = (super.redirectTween.valueST()
						* green(redirectNewTargetC) + (1 - super.redirectTween
						.valueST()) * green(redirectOldTargetC));
				float b = (super.redirectTween.valueST()
						* blue(redirectNewTargetC) + (1 - super.redirectTween
						.valueST()) * blue(redirectOldTargetC));
				float a = (super.redirectTween.valueST()
						* alpha(redirectNewTargetC) + (1 - super.redirectTween
						.valueST()) * alpha(redirectOldTargetC));
				endColor = makeColor(r, g, b, a);
			}
		}
	} // end updateRedirect
} // end class CSTween

