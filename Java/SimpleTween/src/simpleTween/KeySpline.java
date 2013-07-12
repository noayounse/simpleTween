package simpleTween;

import processing.core.PApplet;
import processing.core.PVector;

public class KeySpline { 
  public PVector pt1, pt2;

  public float visualWidth, visualHeight;
  public PVector position;
  public PVector[] bounds;

  public KeySpline (float mX1, float mY1, float mX2, float mY2) {
    pt1 = new PVector(mX1, mY1);
    pt2 = new PVector(mX2, mY2);
  } // end constructor

  KeySpline get() {
    KeySpline cp = new KeySpline(pt1.x, pt1.y, pt2.x, pt2.y);
    cp.visualWidth = visualWidth;
    cp.visualHeight = visualHeight;
    cp.position = position;
    cp.bounds = bounds; 
    return cp;
  } // end get

  public void resetSplineControlPoints(float[] valuesIn ){
	  resetSplineControlPoints(valuesIn[0], valuesIn[1], valuesIn[2], valuesIn[3]);
  } // end resetSplineControlPoints
  public void resetSplineControlPoints(float mX1, float mY1, float mX2, float mY2) {
    pt1 = new PVector(mX1, mY1);
    pt2 = new PVector(mX2, mY2);
  } // end resetSplineControlPoints
  
  public void setVisuals(PVector positionIn, float visualWidthIn, float visualHeightIn) {
    position = positionIn;
    visualWidth = visualWidthIn;
    visualHeight = visualHeightIn;
    bounds = new PVector[2];
    bounds[0] = new PVector(position.x, position.y);
    bounds[1] = new PVector(position.x + visualWidth, position.y + visualHeight);
  } // end setVisuals

  public PVector[] getBounds() {
    return bounds;
  } // end getBounds

    public float findValue(float valueIn) {
    if (pt1.x == pt1.y && pt2.x == pt2.y) return valueIn; // linear
    return CalcBezier(GetTForX(valueIn), pt1.y, pt2.y);
  } // end findValue

  private float A(float aA1, float aA2) { 
    return (float) (1.0 - 3.0 * aA2 + 3.0 * aA1);
  }
  private float B(float aA1, float aA2) { 
    return (float) (3.0 * aA2 - 6.0 * aA1);
  }
  private float C(float aA1) { 
    return (float) (3.0 * aA1);
  }


  // Returns x(t) given t, x1, and x2, or y(t) given t, y1, and y2.
  private float CalcBezier(float aT, float aA1, float aA2) {
    return ((A(aA1, aA2)*aT + B(aA1, aA2))*aT + C(aA1))*aT;
  }

  // Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
  private float GetSlope(float aT, float aA1, float aA2) {
    return (float) (3.0 * A(aA1, aA2)*aT*aT + 2.0 * B(aA1, aA2) * aT + C(aA1));
  }

  private float GetTForX(float aX) {
    // Newton raphson iteration
    float aGuessT = aX;
    for (int i = 0; i < 4; ++i) {
      float currentSlope = GetSlope(aGuessT, pt1.x, pt2.x);
      if (currentSlope == 0.0) return aGuessT;
      float currentX = CalcBezier(aGuessT, pt1.x, pt2.x) - aX;
      aGuessT -= currentX / currentSlope;
    }
    return aGuessT;
  }


  // visuals
  public PVector getStartPosition() {
    if (position != null) {
      return new PVector(position.x, position.y + visualHeight);
    }
    return new PVector();
  } // end getStartPosition
  public PVector getEndPosition() {
    if (position != null) {
      return new PVector(position.x + visualWidth, position.y);
    }
    return new PVector();
  } // end getEndPosition
  public PVector getC1() {
    if (position != null) {
      return new PVector(position.x + visualWidth * pt1.x, position.y + visualHeight - visualHeight * pt1.y);
    }    
    return new PVector();
  } // end getC1
  public PVector getC2() {
    if (position != null) {
      return new PVector(position.x + visualWidth - visualWidth * (1 - pt2.x), position.y + visualHeight * (1 - pt2.y));
    }    
    return new PVector();
  } // end getC2

  public void drawBezier(PApplet parentIn) {
    if (position != null) {
      PVector p1 = getStartPosition();
      PVector p2 = getEndPosition();
      PVector c1 = getC1();
      PVector c2 = getC2();

      parentIn.stroke(0);
      parentIn.noFill();
      parentIn.rect(p1.x, p1.y, visualWidth, -visualHeight);
      parentIn.bezier(p1.x, p1.y, c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);

      parentIn.fill(0);
      parentIn.ellipse(p1.x, p1.y, 4, 4);

      parentIn.fill(255, 0, 0);
      parentIn.ellipse(p2.x, p2.y, 4, 4);

      parentIn.fill(0, 255, 0);
      parentIn.ellipse(c1.x, c1.y, 6, 6);
      parentIn.line(p1.x, p1.y, c1.x, c1.y);

      parentIn.fill(0, 0, 255);
      parentIn.ellipse(c2.x, c2.y, 6, 6);
      parentIn.line(p2.x, p2.y, c2.x, c2.y);
    }
  } // end drawBezier

  public String toString() {
    String builder = "KeySpline: p1: " + pt1.x + ", " + pt1.y + " -- pt2: " + pt2.x + ", " + pt2.y;
    return builder;
  } // end toString
} // end class KeySpline
