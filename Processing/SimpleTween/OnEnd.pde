class OnEnd extends Thread {
  Object targetObj;
  STweenManager referenceObj;
  String functionName;
  int lastFrame = 0;

  boolean running;
  boolean playedThrough = false;

  OnEnd (Object targetObj_, STweenManager referenceObj_, String functionName_) {
    targetObj = targetObj_;
    referenceObj = referenceObj_;
    functionName = functionName_;
    running = false;
  } // end constructor

  void start() {
    running = true;
    super.start();
  } // end start

    void run() {
    while (running) {
      if (frameCount != lastFrame) { 
        try {
          if (referenceObj.isDone() && referenceObj.nextTargets.size() == 0) {
            playFunction();
            this.quit();
          }
        } 
        catch (Exception e) {
          println("error trying to run " + functionName);
        }
        lastFrame = frameCount;
      }
    }
  } // end run

  void playFunction() {
    // see http://stackoverflow.com/questions/160970/how-do-i-invoke-a-java-method-when-given-the-method-name-as-a-string
    java.lang.reflect.Method method;
    try {
      //method = obj.getClass().getMethod(methodName, param1.class, param2.class, ..);
      method = targetObj.getClass().getMethod(functionName);
      try {
        method.invoke(targetObj);
        //println(frameCount + "--- firing function: " + functionName);
      }
      catch (IllegalArgumentException e) {
        println("illegal argument exception");
      } 
      catch (IllegalAccessException e) {
        println("illegal access exception");
      } 
      catch (Exception e) {
        println("some other exception");
      }
    } 
    catch (SecurityException e) {
      println("security exception");
    } 
    catch (NoSuchMethodException e) {
      println("no such method exception");
    }
  } // end playFunction

    void quit() {
    //println("quitting thread");
    running = false;
    interrupt();
    playedThrough = true;
    try {
      referenceObj.removeFinishedOnEnds();
    }
    catch (Exception e) {
    }
  } // end quit
} // end class OnEnd

