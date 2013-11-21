package simpleTween;

public class OnEnd extends Thread {
	private Object targetObj;
	private STweenManager referenceObj;
	String functionName;
	private int lastFrame = 0;

	private boolean frameTestedAlready = false; // a stupid variable required to get this thing to register for some reason

	public boolean running;
	public boolean playedThrough = false;

	public OnEnd(Object targetObj_, STweenManager referenceObj_,
			String functionName_) {
		targetObj = targetObj_;
		referenceObj = referenceObj_;
		functionName = functionName_;
		running = false;
	} // end constructor

	public void start() {
		running = true;
		super.start();
	} // end start

	public int getLastFrame() {
		return lastFrame;
	} // end getLastFrame

	public void run() {
		while (running) {
			////////////
			if (!frameTestedAlready) {
				@SuppressWarnings("unused")
				long test = SimpleTween.parent.millis();
				frameTestedAlready = true;
			}
			if (SimpleTween.parent.frameCount != lastFrame)
				frameTestedAlready = false;
			////////////
			if (SimpleTween.parent.frameCount != lastFrame) {
				lastFrame = SimpleTween.parent.frameCount;
				try {
					@SuppressWarnings("unused")
					float iterate = referenceObj.valueFloatArray()[0];
					if (referenceObj.isDone()
							&& referenceObj.nextTargets.size() == 0) {
						playFunction();
						this.quit();
					}
				} catch (Exception e) {
					 System.out.println("error trying to run " + functionName);
				}
			}
		}
	} // end run

	void playFunction() {
		// System.out.println("in playFunction trying to play: " +
		// functionName);
		// see
		// http://stackoverflow.com/questions/160970/how-do-i-invoke-a-java-method-when-given-the-method-name-as-a-string
		java.lang.reflect.Method method;
		try {
			method = targetObj.getClass().getMethod(functionName);
			try {
				if (!method.isAccessible()) {
					method.setAccessible(true);
				}
				method.invoke(targetObj);
			} catch (IllegalArgumentException e) {
				System.out.println("illegal argument exception");
			} catch (IllegalAccessException e) {
				System.out.println("illegal access exception");
			} catch (Exception e) {
				System.out.println("some other exception");
			}
		} catch (SecurityException e) {
			System.out.println("security exception");
		} catch (NoSuchMethodException e) {
			System.out.println("no such method exception");
		}
	} // end playFunction

	void quit() {
		// System.out.println("quitting thread");
		running = false;
		interrupt();
		playedThrough = true;
		try {
			referenceObj.removeFinishedOnEnds();
		} catch (Exception e) {
		}
	} // end quit
} // end class OnEnd

