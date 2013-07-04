package simpleTween;

import java.util.ArrayList;

public class STweenManager {
	ArrayList<STween> allTweens = new ArrayList<STween>();

	ArrayList<OnEnd> onEnds = new ArrayList<OnEnd>();

	public float[] brokenValuesStart;
	public float[] brokenValuesEnd;

	private STween base;

	private int degree = 1;

	// targets
	public ArrayList<NextTarget> nextTargets = new ArrayList<NextTarget>();

	public STweenManager(int degree_) {
		base = new STween(13, 0, 0, 1);
		base.setTimeMode(SimpleTween.baseTimeMode);
		degree = degree_;
	} // end constructor

	public void setInitialTweens(float duration_, float delay_,
			float[] brokenValuesStart_, float[] brokenValuesEnd_) {
		brokenValuesStart = brokenValuesStart_;
		brokenValuesEnd = brokenValuesEnd_;

		for (int i = 0; i < degree; i++)
			allTweens.add(new STween(duration_, delay_, brokenValuesStart[i],
					brokenValuesEnd[i]));
		for (int i = 0; i < degree; i++)
			allTweens.get(i).setMode(base.mode);
	} // end setInitialTweens

	public void setModeLinear() {
		base.setModeLinear();
		setMode();
	} // end setModeLinear

	public void setModeCubicBoth() {
		base.setModeCubicBoth();
		setMode();
	} // end setModeCubic

	public void setModeCubicIn() {
		base.setModeCubicIn();
		setMode();
	} // end setModeCubicIn()

	public void setModeCubicOut() {
		base.setModeCubicOut();
		setMode();
	} // end setModeCubicOut()

	public void setModeQuadBoth() {
		base.setModeQuadBoth();
		setMode();
	} // end setModeQuadBot

	public void setModeQuarticBoth() {
		base.setModeQuarticBoth();
		setMode();
	} // end setModeQuarticBoth

	public void setModeQuintIn() {
		base.setModeQuintIn();
		setMode();
	} // end setModeQuintIn

	public void setMode() {
		for (int i = 0; i < degree; i++)
			allTweens.get(i).setMode(base.mode);
	} // end setMode
	
	public void setMode(int modeIn) {
		base.setMode(modeIn);
		for (int i = 0; i < degree; i++) allTweens.get(i).setMode(modeIn);
	} // end setMode

	public void setTimeToFrames() {
		setTimeMode(SimpleTween.FRAMES_MODE);
	} // end setTimeToFrames

	public void setTimeToSeconds() {
		setTimeMode(SimpleTween.SECONDS_MODE);
	} // end setTimeToSeconds

	public void setTimeMode(int modeIn) {
		for (int i = 0; i < degree; i++)
			allTweens.get(i).setTimeMode(modeIn);
		base.setTimeMode(modeIn);
	} // end setTimeMode

	public int getTimeMode() {
		return base.getTimeMode();
	} // end getTimeMode

	public void play() {
		// if there are no next targets, play the original
		if (nextTargets.size() == 0)
			for (int i = 0; i < degree; i++)
				allTweens.get(i).play();
		// otherwise play the next target
		else
			startNextTarget();
		// start any onEnds
		startOnEnds();
	} // end play

	public void pause() {
		for (int i = 0; i < allTweens.size(); i++)
			allTweens.get(i).pause();
	} // end pause
	
	public boolean isPaused() {
		return allTweens.get(0).isPaused();
	} // end isPaused

	public void reset() {
		for (int i = 0; i < allTweens.size(); i++)
			allTweens.get(i).reset();
		nextTargets = new ArrayList<NextTarget>();
	}

	public void quitOnEnds() {
		for (int i = 0; i < onEnds.size(); i++) {
			onEnds.get(i).quit();
		}
	 } // end quitOnEnds
	
	public void setCurrent(float[] valuesIn) {
		reset();
		setBegin(valuesIn);
	} // end setCurrent
	
	public void setBegin(float[] valuesIn) {
		for (int i = 0; i < allTweens.size(); i++)
			allTweens.get(i).setBegin(valuesIn[i]);
	} // end setBegin

	public void setEnd(float[] valuesIn) {
		for (int i = 0; i < allTweens.size(); i++)
			allTweens.get(i).setEnd(valuesIn[i]);
	} // end setEnd

	public void setDuration(float durationIn) {
		for (int i = 0; i < allTweens.size(); i++)
			allTweens.get(i).setDuration(durationIn);
	} // end setDuration

	public void setDelay(float delayIn) {
		for (int i = 0; i < allTweens.size(); i++)
			allTweens.get(i).setDelay(delayIn);
	} // end setDelay

	public float[] getBrokenBegin() {
		float[] broken = new float[degree];
		for (int i = allTweens.size() - 1; i < allTweens.size(); i++)
			broken[i] = allTweens.get(i).getBegin();
		return broken;
	} // end getBrokenBegin

	public float[] getBrokenEnd() {
		float[] broken = new float[degree];
		for (int i = allTweens.size() - 1; i < allTweens.size(); i++)
			broken[i] = allTweens.get(i).getEnd();
		return broken;
	} // end getBrokenEnd

	public float getDuration() {
		return allTweens.get(0).getDuration();
	} // end getDuration

	public float getDelay() {
		return allTweens.get(0).getDelay();
	} // end getDelay

	public void playLive(float[] valuesIn, float durationIn, float delayIn) {
		float[] currentValues = new float[degree];
		for (int i = 0; i < degree; i++)
			currentValues[i] = allTweens.get(i).getCurrent();
		if (!isPlaying()) {
			if (nextTargets.size() == 0) {
				allTweens = new ArrayList<STween>();
				for (int i = 0; i < degree; i++)
					allTweens.add(new STween(durationIn, delayIn,
							currentValues[i], valuesIn[i]));
				for (int i = 0; i < degree; i++)
					allTweens.get(i).setMode(base.mode);
				for (int i = 0; i < degree; i++)
					allTweens.get(i).setTimeMode(base.timeMode);
				for (int i = 0; i < degree; i++)
					allTweens.get(i).play();
			} else {
				addNextTarget(durationIn, delayIn, valuesIn, base.timeMode);
				startNextTarget();
			}
		} else {
			for (int i = 0; i < degree; i++) {
				allTweens.get(i).playLive(valuesIn[i], durationIn, delayIn);
			}
			for (int i = 0; i < degree; i++) allTweens.get(i).adjustDurations();
		}
		// start any onEnds
		startOnEnds();
	} // end playLive

	public float[] valueFloatArray() {
		float[] broken = new float[degree];
		for (int j = 0; j < degree; j++)
			broken[j] += allTweens.get(j).value();

		// look for and assign any nextTargets
		if (hasStarted() && !isPlaying() && isDone() && nextTargets.size() > 0) {
			startNextTarget();
		}

		if (nextTargets.size() == 0 && isDone())
			resetHasStarted();
		return broken;
	} // end value

	public void startNextTarget() {
		NextTarget nextTarget = nextTargets.get(0);
		nextTargets.remove(0);
		float[] nextTar = nextTarget.getTarget();
		ArrayList<STween> newDirection = new ArrayList<STween>();
		for (int i = 0; i < degree; i++) {
			STween newDir = new STween(nextTarget.getDuration(),
					nextTarget.getDelay(), allTweens.get(i).value(), nextTar[i]);
			newDir.setMode(base.mode);
			newDir.setTimeMode(nextTarget.timeMode);
			newDir.play();
			newDirection.add(newDir);
		}
		allTweens = new ArrayList<STween>();
		for (int i = 0; i < degree; i++)
			allTweens.add(newDirection.get(i));
	} // end startNextTarget

	public boolean isPlaying() {
		for (STween st : allTweens)
			if (st.isPlaying())
				return true;
		return false;
	} // end isPlaying

	public boolean isDone() {
		boolean done = true;
		for (STween st : allTweens) {
			if (!st.isDone())
				done = false;
		}
		return done;
	} // end isDone

	public boolean hasStarted() {
		for (STween st : allTweens)
			if (st.hasStarted())
				return true;
		return false;
	} // end hasStarted

	public void resetHasStarted() {
		for (int i = 0; i < degree; i++)
			allTweens.get(i).resetHasStarted();
	} // end resetHasStarted

	public void addNextTarget(float durationIn, float delayIn,
			float[] valuesIn, int timeModeIn) {
		nextTargets.add(new NextTarget(durationIn, delayIn, valuesIn,
				timeModeIn));
	} // end addNextTarget

	public void clearTargets() {
		nextTargets = new ArrayList<NextTarget>();
	} // end clearTargets

	public STween setToBaseMode(STween stIn) {
		stIn.setMode(base.mode);
		return stIn;
	} // end setToBaseMode

	// onEnd stuff
	public void onEnd(Object targetObj, String functionName) {
		OnEnd newOnEnd = new OnEnd(targetObj, this, functionName);
		onEnds.add(newOnEnd);
		if (isPlaying())
			startOnEnds();
	} // end onEnd

	public void startOnEnds() {
		for (int i = 0; i < onEnds.size(); i++)
			if (!onEnds.get(i).running && !onEnds.get(i).playedThrough)
				onEnds.get(i).start();
	} // end startOnEnds

	public void clearOnEnds() {
		for (int i = onEnds.size() - 1; i >= 0; i--) {
			if (onEnds.get(i).running) {
				onEnds.get(i).quit();
			}
			onEnds.remove(i);
		}
	} // end clearOnEnds

	public void removeFinishedOnEnds() {
		for (int i = onEnds.size() - 1; i >= 0; i--) {
			if (onEnds.get(i).playedThrough) {
				onEnds.remove(i);
			}
		}
	} // end removeFinishedOnEnds
} // end class PVSTween

