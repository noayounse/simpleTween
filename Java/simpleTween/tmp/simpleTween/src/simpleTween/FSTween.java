package simpleTween;

public class FSTween extends STween {
	  private float startFloat = 0f;
	  private float endFloat = 1f;

	  private float valueF;

	  // redirect vars
	  private float redirectOldBeginF;
	  private float redirectNewBeginF;
	  private float redirectNewTargetF;
	  private float redirectOldTargetF;

	   public FSTween (int duration_, int delay_, float startFloat_, float endFloat_) {
	    super(duration_, delay_);
	    startFloat = startFloat_;
	    endFloat = endFloat_;
	    valueF = startFloat;
	  } // end constructor
		  
	   public void playLive(float valueIn) {
	    if (valueIn - endFloat != 0 || (!super.isPlaying() && startFloat != endFloat)) {
	      //if (super.isPlaying() && super.redirectTween == null) {
	    	if (super.isPlaying()) {
	        redirect(valueIn);
	        //System.out.print("making new redirect.  trying to go from old end: " + endFloat + " to new end: " + valueIn);
	      }
	      else if (!super.isPlaying() && !super.inRedirect) {
	        setBegin(valueF);
	        setEnd(valueIn);
	        super.play();
	      }
	      else return;
	    }
	  } // end playLive


	  @Override
	public void setBegin(float valueIn) {
	    startFloat = valueIn;
	  } // end setBegin

	  @Override
	public void setEnd (float valueIn) {
	    setBegin(valueF);
	    super.setBegin(0);
	    endFloat = valueIn;
	  } // end setEnd

	  public float getBegin() {
	    return startFloat;
	  } // end getBegin

	  public float getEnd () {
	    return endFloat;
	  } // end getEnd

	  public float value() {
	    updateRedirectC();
	    float multiplier = super.valueST();
	    if (multiplier == 1) valueF = endFloat;
	    else if (multiplier == 0) valueF = startFloat;
	    else {
	      valueF = (multiplier * endFloat) + (1 - multiplier) * startFloat;
	    }
	    // look for and assign any nextTargets
	    if (!super.isPlaying() && super.isDone() && super.nextTargets.size() > 0) {
	      NextTarget nextTarget = super.nextTargets.get(0);
	      super.nextTargets.remove(0);
	      super.setDuration(nextTarget.getDuration());
	      super.setDelay(nextTarget.getDelay());
	      setEnd((Float)nextTarget.getTarget());
	      super.play();
	    } 
	    return valueF;
	  } // end value

	  private void redirect(float f) {
	    //if (super.isPlaying && super.redirectTween == null) {
		  if (super.isPlaying) {
	      super.redirect();
	      redirectNewTargetF = f;
	      redirectOldTargetF = getEnd();
	      redirectNewBeginF = (valueF + getEnd()) / 2.0;
	      redirectOldBeginF = getBegin();
	    }
	  } // end redirect  

	    private void updateRedirectC() {
	    if (super.inRedirect) {
	      if (super.redirectTween.isDone()) {
	        endFloat = redirectNewTargetF;
	        startFloat = redirectNewBeginF;
	      }
	      else {        
	        endFloat = (super.redirectTween.valueST() * redirectNewTargetF) + (1 - super.redirectTween.valueST()) * redirectOldTargetF;
	        startFloat = (super.redirectTween.valueST() * redirectNewBeginF) + (1 - super.redirectTween.valueST()) * redirectOldBeginF;
	      }
	    }
	  } // end updateRedirect
	} // end class FTween
