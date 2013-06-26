/**
 * ##library.name##
 * ##library.sentence##
 * ##library.url##
 *
 * Copyright ##copyright## ##author##
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author      ##author##
 * @modified    ##date##
 * @version     ##library.prettyVersion## (##library.version##)
 */

package simpleTween;

import java.util.Arrays;

import processing.core.*;

/**
 * This is a template class and can be used to start a new processing library or
 * tool. Make sure you rename this class as well as the name of the example
 * package 'template' to your own library or tool naming convention.
 * 
 * @example Hello
 * 
 *          (the tag @example followed by the name of an example included in
 *          folder 'examples' will automatically include the example in the
 *          javadoc.)
 * 
 */

public class SimpleTween implements PConstants {

	// myParent is a reference to the parent sketch
	public static PApplet parent;

	// timer constants
	public final static int FRAMES_MODE = 1;
	public final static int SECONDS_MODE = 2;
	public static int baseTimeMode = FRAMES_MODE;
	

	// easing constants
	public final static int LINEAR = 0;
	public final static int QUAD_BOTH = 1;
	public final static int CUBIC_BOTH = 2;
	public final static int QUARTIC_BOTH = 3;
	public final static int QUINT_IN = 20;
	public final static int CUBIC_IN = 22;
	public final static int CUBIC_OUT = 23;
	public static int baseEasingMode = QUARTIC_BOTH;

	public final static String VERSION = "##library.prettyVersion##";

	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the library.
	 * 
	 * @example Hello
	 * @param theParent
	 */
	public SimpleTween(PApplet theParent) {
		parent = theParent;
	}

	public static void begin(PApplet theParent) {
		parent = theParent;
	}
	
	/**
	 * return the version of the library.
	 * 
	 * @return String
	 */
	public static String version() {
		return VERSION;
	}

	/**
	 * 
	 * @param theA
	 *            the width of test
	 * @param theB
	 *            the height of test
	 */
	public void setVariable(int theA, int theB) {
		// myVariable = theA + theB;
	}

	/**
	 * 
	 * @return int
	 */
	public int getVariable() {
		// return myVariable;
		return 0;
	}

	public static void setTimeToSeconds() {
		baseTimeMode = SECONDS_MODE;
	} // end setTimeToSeconds
	public static void setTimeToFrames() {
		baseTimeMode = FRAMES_MODE;
	} // end setTimeToSeconds
	public static int getTimeMode() {
	return baseTimeMode;	
	} // end getTimeMode
	
	public static void setModeLinear() {
		baseEasingMode = LINEAR;
	} // end setModeLinear

	public static void setModeCubicBoth() {
		baseEasingMode = CUBIC_BOTH;
	} // end setModeCubic

	public static void setModeCubicIn() {
		baseEasingMode = CUBIC_IN;
	} // end setModeCubicIn

	public static void setModeCubicOut() {
		baseEasingMode = CUBIC_OUT;
	} // end setModeCubicOut

	public static void setModeQuadBoth() {
		baseEasingMode = QUAD_BOTH;
	} // end setModeQuadBot

	public static void setModeQuarticBoth() {
		baseEasingMode = QUARTIC_BOTH;
	} // end setModeQuarticBoth

	public static void setModeQuintIn() {
		baseEasingMode = QUINT_IN;
	} // end setModeQuintIn
	
	public static int getEasingMode() {
		return baseEasingMode;
	} // end getEasingMode
	
	public static float[] append(float[] fIn, float addition) {
		float[] result = Arrays.copyOf(fIn, fIn.length + 1);
		result[fIn.length] = addition;
		return result;
	} // end append

	public static float[][] append(float[][] fIn, float[] addition) {
		float[][] result = Arrays.copyOf(fIn, fIn.length + 1);
		result[fIn.length] = addition;
		return result;
	} // end append

}
