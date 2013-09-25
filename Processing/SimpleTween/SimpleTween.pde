FSTween fst;
PVSTween pvst;
CSTween cst;
ISTween ist;
BSTween bst; 

MSTween mst;

Dot testDot;

ArrayList<Dot> dots;
color cursorColor;

boolean tempPrintDone = true;

void setup() {
  size(800, 300);
  fst = new FSTween(4, 0, 20, width - 20);
  fst.setTimeToSeconds();
  pvst = new PVSTween(4, 1, new PVector(33, 20), new PVector(width/2, height/2));
  pvst.setTimeToSeconds();
  cst = new CSTween(2.4, 0, color(0, 0, 255), color(255, 0, 0));
  cst.setTimeToSeconds();
  /*
  //fst.addNextTarget(100, 30, 100f);
   //fst.addNextTarget(200, 100, 400f);
   //fst.addNextTarget(40, 100, 200f);
   //fst.addNextTarget(200, 30, 600f);
   */

  ist = new ISTween(10, 0, 20, 40);
  ist.setTimeToSeconds();
  //ist.setModeLinear();
  ist.setEaseLinear();

  dots = new ArrayList<Dot>();
  float padding = 8;
  float lim = 20;
  for (int i = 0; i <= lim; i++) {
    for (int j = 0; j <= lim * ((float)height / width); j++) {
      float xPos = map(i, 0, lim, padding, width - padding);
      float yPos = map(j, 0, lim * ((float)height / width), padding, height - padding);
      dots.add(new Dot(new PVector(xPos, yPos)));
    }
  }  

  bst = new BSTween(100);

  testDot = new Dot(new PVector(width/3, height/3));
  testDot.rad = 36f;
  testDot.c = color(255, 255, 0);

  mst = new MSTween(4, "mySimpleTestMethod", testDot);
  mst.setTimeToSeconds();

  //pvst.onEnd(testDot, "mySimpleTestMethod");
  
} // end setup


void draw() {
  background(255);

  if (frameCount % 5 == 0) {
    //println("pvst.isPlaying() : " + pvst.isPlaying() + " pvst.isDone(): " + pvst.isDone());
    //println("mst.isPlaying(): " + mst.isPlaying());
  }

  for (Dot d : dots) d.display();

  loadPixels();
  cursorColor = get(mouseX, mouseY);

  fill(0, 255, 0);
  stroke(0);
  ellipse(ist.value(), height / 3, 20, 20);
  fill(0);
  text(ist.value(), ist.value(), height / 3 + 30);

  fill(255, 0, 0);
  ellipse(fst.value(), height / 2, 20, 20);
  textAlign(CENTER);
  fill(0);

  fill(cst.value());
  ellipse(pvst.value().x, pvst.value().y, 50, 50);
  fill(0);
  text(pvst.value().x + ", " + pvst.value().y, pvst.value().x, pvst.value().y -30);

  if (tempPrintDone && pvst.isDone()) {
    println("pvst is done: " + frameCount + "... " + nf((float)millis() / 1000, 0, 2));
    tempPrintDone = false;
  }

  fill(0);
  text(mouseX + ", " + mouseY, mouseX, mouseY + 20);

  strokeWeight(3);
  stroke(255);
  drawCross(new PVector(mouseX, mouseY));  
  strokeWeight(1);
  stroke(cursorColor);
  drawCross(new PVector(mouseX, mouseY));


  if (bst.fire()) {
    println(frameCount + " bst fire()");
  } // end if

  testDot.display();

  fill(0);
  textAlign(LEFT);
  text("frameRate: " + (int)frameRate, 20, height - 20);
  

} // end draw

void drawCross(PVector loc) {
  line(loc.x - 5, loc.y, loc.x + 5, loc.y);
  line(loc.x, loc.y - 5, loc.x, loc.y + 5);
} // end drawCross

void mouseReleased() {  
  fst.playLive(mouseX);

  if (!pvst.isPlaying()) pvst.playLive(new PVector(mouseX, mouseY), 5, 0);
  else pvst.playLive(new PVector(mouseX, mouseY),2, 0);

  //pvst.playLive(new PVector(mouseX, mouseY));
  println("clicked: " + frameCount + "... " + nf((float)millis() / 1000, 0, 2));
  tempPrintDone = true;
  cst.playLive(cursorColor);
  bst.playLive(100);
  mst.play();
  
} // end mouseReleased


void keyReleased() {
  if (key == 'p') {
    pvst.play();
    fst.play();
    cst.play();
    ist.play();
    bst.play();
    println("pressed play at frame: " + frameCount);
  }
  if (key == ' ') {
    if (fst.isPaused()) {
      pvst.resume();
      fst.resume();
      //cst.resume();
    }
    else {
      pvst.pause();
      fst.pause();
      //cst.pause();
    }
  } 

  if (key == 'o') {
    pvst.onEnd(testDot, "totalTest");
  }

  if (key == 't') {
    pvst.playLive(new PVector(width/2, height/4), 200, 0);
    pvst.playLive(new PVector(width, height), 200, 100);
  } 

  if (key == 'r') {
    pvst.reset();
    //fst.reset();
    cst.reset();
  }
  /*
  if (key == '1') pvst.setModeLinear();
  if (key == '2') pvst.setModeCubicBoth();
  if (key == '3') pvst.setModeQuadBoth();
  if (key == '4') pvst.setModeQuarticBoth();
  if (key == '5') pvst.setModeQuintIn();
  */

  if (key == 'l') {
    pvst.addNextTarget(new PVector(mouseX, mouseY));
    fst.addNextTarget(4, 0, mouseX, 2);
    cst.addNextTarget(cursorColor);
  }
  if (key == 'k') {
    fst.addNextTarget(20, 0, mouseX, 1);
  }

  if (key == 'q') pvst.setDuration(3);
  if (key == 'w') pvst.setDuration(6);
  if (key == 'e') {
    println("pvst.getEnd(): " + pvst.getEnd());
  }
  if (key == 'f') pvst.setDelay(1);

  if (key == 'c') {
    pvst.toggleAdjustForFasterPlayLive();
  }

  if (key == 'd') {
    for (int i = 0; i < dots.size(); i++) {
      dots.get(i).pos.setTimeToSeconds();
      dots.get(i).pos.playLive(new PVector(random(width), random(height)), random(2, 5), random(0, 3));
    }
  }

  if (keyCode == SHIFT) {
    //pvst.jitter(new PVector(10, 0, 0), 20, 0);
  } 

  if (key == '9') {
    println("trying to stop mst");
    mst.stop();
  }
} // end keyReleased


// to do: delay, pause, next





class Dot {
  PVSTween pos;
  color c; 
  boolean sayHello = false;
  float rad = 25;

  Dot (PVector pos_) {
    c = color(random(255), random(255), random(255));
    pos = new PVSTween(1, 0, pos_, pos_);
  } // end constructor

  void display() {
    noStroke();
    fill(c);
    stroke(c);
    //ellipse(pos.value().x, pos.value().y, rad, rad);
    //point(pos.value().x, pos.value().y);
    float a = pos.value().x;
    float b = pos.value().y;
    rectMode(CENTER);
    rect(a, b, rad / 2, rad / 2);
    if (sayHello) {
      fill(0);
      textAlign(CENTER);
      text("hello", pos.value().x, pos.value().y + 50);
    }
  } // end display

  void sayHello() {
    sayHello = !sayHello;
  } // end sayHello

    void totalTest() {
    c = color(0);
    println(frameCount + "--- totalTest");
  } // end totalTest


  void mySimpleTestMethod() {
    println(frameCount + "--- this is my simple test method");
  } // end mySimpleTestMethod
} // end class Dot

