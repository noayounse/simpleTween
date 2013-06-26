package simpleTween;

public class PVSTween extends STween {
	private processing.core.PVector startPV = new processing.core.PVector();
	private processing.core.PVector endPV = new processing.core.PVector();
	private processing.core.PVector valuePV = new processing.core.PVector();

	// redirect vars
	private processing.core.PVector redirectNewTargetPV = new processing.core.PVector();
	private processing.core.PVector redirectOldTargetPV = new processing.core.PVector();

	public PVSTween(int duration_, int delay_,
			processing.core.PVector startPV_, processing.core.PVector endPV_) {
		super(duration_, delay_);
		startPV = startPV_;
		endPV = endPV_;
		valuePV = startPV.get();
	} // end constructor

	public void playLive(processing.core.PVector valueIn) {
		if ((valueIn.x - endPV.x != 0 || valueIn.y - endPV.y != 0 || valueIn.z
				- endPV.z != 0)
				|| (!super.isPlaying() && ((startPV.x != endPV.x
						&& startPV.y != endPV.y && startPV.z != endPV.z)))) {
			if (super.isPlaying() && !super.inRedirect) {
				redirect(valueIn);
			} else if (!super.isPlaying() && !super.inRedirect) {
				setBegin(valuePV);
				setEnd(valueIn);
				super.play();
			} else
				return;
		}
	} // end playLive

	public void setBegin(processing.core.PVector valueIn) {
		startPV = valueIn;
	} // end setBegin

	public void setEnd(processing.core.PVector valueIn) {
		setBegin(valuePV);
		super.setBegin(0);
		endPV = valueIn;
	} // end setEnd

	public processing.core.PVector getBegin() {
		return startPV;
	} // end getBegin

	public processing.core.PVector getEnd() {
		return endPV;
	} // end getEnd

	public processing.core.PVector value() {
		updateRedirectPV();
		float multiplier = super.valueST();
		// println("multiplier: " + multiplier);
		if (multiplier == 1)
			valuePV = endPV.get();
		else if (multiplier == 0)
			valuePV = startPV.get();
		else {
			processing.core.PVector diff = processing.core.PVector.sub(endPV,
					startPV);
			diff.mult(multiplier);
			valuePV = processing.core.PVector.add(startPV, diff);
		}
		// look for and assign any nextTargets
		if (!super.isPlaying() && super.isDone()
				&& super.nextTargets.size() > 0) {
			NextTarget nextTarget = super.nextTargets.get(0);
			super.nextTargets.remove(0);
			super.setDuration(nextTarget.getDuration());
			super.setDelay(nextTarget.getDelay());
			setEnd((processing.core.PVector) nextTarget.getTarget());
			super.play();
		}
		return valuePV;
	} // end value

	void redirect(processing.core.PVector valueIn) {
		if (super.isPlaying && super.redirectTween == null) {
			super.redirect();
			redirectNewTargetPV = valueIn.get();
			redirectOldTargetPV = endPV.get();
		}
	} // end redirect

	// note to self... ideally maybe the start position should shift too...?
	void updateRedirectPV() {
		if (super.inRedirect) {
			if (super.redirectTween.isDone()) {
				endPV = redirectNewTargetPV.get();
			} else {
				processing.core.PVector a = processing.core.PVector.mult(
						redirectNewTargetPV, (super.redirectTween.valueST()));
				processing.core.PVector b = processing.core.PVector.mult(
						redirectOldTargetPV,
						(1 - super.redirectTween.valueST()));
				endPV = processing.core.PVector.add(b, a);
			}
		}
	} // end updateRedirect
} // end class PVSTween
