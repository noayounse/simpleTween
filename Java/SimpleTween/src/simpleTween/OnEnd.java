package simpleTween;

public class OnEnd extends Thread {
	private Object targetObj;
	private STweenManager referenceObj;
	String functionName;
	private int lastFrame = 0;

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

	public void run() {
		while (running) {
			if (SimpleTween.parent.frameCount != lastFrame) {
				try {
					float iterate = referenceObj.valueFloatArray()[0];
					if (referenceObj.isDone()
							&& referenceObj.nextTargets.size() == 0) {
						playFunction();
						this.quit();
					}
				} catch (Exception e) {
					System.out.println("error trying to run " + functionName);
				}
				lastFrame = SimpleTween.parent.frameCount;
			}
		}
	} // end run

	void playFunction() {
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
		// println("quitting thread");
		running = false;
		interrupt();
		playedThrough = true;
		try {
			referenceObj.removeFinishedOnEnds();
		} catch (Exception e) {
		}
	} // end quit
} // end class OnEnd

