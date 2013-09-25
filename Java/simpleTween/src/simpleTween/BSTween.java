package simpleTween;

public class BSTween extends STween {
	  private boolean valueB = false;

	  public BSTween (float duration_) {
	    super(duration_, 0, 0, 1);
	    //super.setModeLinear();
	    super.setEaseLinear();
	  } // end constructor

	  public BSTween get() {
		  BSTween dupe = new BSTween(super.getDuration());
		  return dupe;
	  } // end get
	  
	    public void playLive(float newDuration) {
	    super.reset();
	    super.setDuration(newDuration);
	    play();
	  } // end playLive

	  public void play() {
	    super.play();
	  } 


	    // fire will look at the value() and when it is true will toggle a fire and automatically reset the tween
	  public boolean fire() {
	    boolean fire = false;
	    if (super.value() == 1) {
	      fire = true;
	      super.reset();
	    } 
	    else fire = false; 
	    return fire;
	  } // end fire

	    // value will return the value of valueB.  unlike fire(), it will not reset it
	  public boolean state() {
	    float multiplier = super.value();
	    if (multiplier == 1) {
	      valueB = true;
	    }
	    else valueB = false;
	    return valueB;
	  } // end value
} // end class BSTween
