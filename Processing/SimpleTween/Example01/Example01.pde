import camcam.*;
import simpleTween.*;

CamCam cam;

ArrayList<Thing> things;
int totalThings = 50;



void setup() {
  SimpleTween.begin(this);
  cam = new CamCam(this);
  size(900, 700, P3D);
  
  smooth();
  things = new ArrayList<Thing>();
  for (int i = 0; i < totalThings; i++) {
    things.add(new Thing());
  } // end i for
} // end setup


void draw() {
  //float z = map(mouseY, 0, height, -PI/2, PI/2);
  //camera(400 * cos(map(mouseX, 0, width, 0, PI)) * cos(z), 400 * sin(map(mouseX, 0, width, 0, PI))* cos(z), 400 * sin(z), 0, 0, 0, 0, 0, -1);
  cam.useCamera();
  background(255);
  for (int i = things.size() - 1; i >= 0; i-- ) {
    things.get(i).display();
   if (things.get(i).okToDie()) things.remove(i); 
  }

  

camera();
  fill(0);
  text("frameRate: " + frameRate, 20, height - 20);
  text("total things: " + things.size(), 20, height - 40);
} // end draw

void mouseReleased() {
  for (int i = 0; i < things.size(); i++) things.get(i).makeNewPos(new PVector(random(-200, 200), random(-200, 200), random(-200, 200)));
} // end mouseReleased

void myTestFunction() {
  println(frameCount + "--- playing my test function");
} // end myTestFunction

void otherTestFunction() {
  println(frameCount + "=== OTHER test function");
} // end otherTestFunction

void keyReleased() {
 
  if (key == ' ') {
    if (SimpleTween.getTimeMode() == SimpleTween.SECONDS_MODE) SimpleTween.setTimeToFrames();
    else SimpleTween.setTimeToSeconds();
    println("new time mode as: " + SimpleTween.getTimeMode());
  }
 
  if (key == '1') setAllEasingModes(SimpleTween.LINEAR);
  if (key == '2') setAllEasingModes(SimpleTween.CUBIC_BOTH);
  if (key == '3') setAllEasingModes(SimpleTween.QUAD_BOTH);
  if (key == '4') setAllEasingModes(SimpleTween.QUARTIC_BOTH);
  
  if (key == 'f') cam.toggleFreeControl();
  if (key == '0') cam.toTopView();
  if (key == '9') cam.toLeftView();
  if (key == '8') cam.toRightView();


  if (key == 'q') {
    int addSubtract = (int)random(50, things.size());
    addSubtract = addSubtract > things.size() ? things.size() : addSubtract;
    println("replacing " + addSubtract + " from the grouping");
    for (int i = things.size() - 1; i >= things.size() - addSubtract; i--) {
     things.get(i).rad.playLive(0f);
    }
    for (int i = 0; i < addSubtract; i++) {
      things.add(new Thing());
    } // end i for
  }
} // end keyReleased

void setAllEasingModes (int modeIn) {
  for (int i = 0; i < things.size(); i++) things.get(i).setMode(modeIn);
} // end setAllEasingModes

