STween simple;
PVSTween simplePV;
STween alph;

void setup() {
  size(1000, 200);
  simple = new STween(200f, 0f, (float)width / 8, 7 * (float)width / 8);
  simplePV = new PVSTween(200f, 0f, new PVector(50, 50), new PVector(width - 50, height - 20));
  alph = new STween(200f, 0f, 0f, 255f);
  alph.setModeLinear();
  textFont(createFont("Helvetica", 30));
} // end setup

void draw() {
  background(255);
  stroke(0);
  fill(255, 0, 0, 50);
  ellipse(simple.value(), height/2, 20, 20);
  fill(0);
  text(simple.percent, simple.value(), height/2 + 20);
  fill(0, 255, 0, 50);
  ellipse(simplePV.value().x, simplePV.value().y, 20, 20);
  fill(0, alph.value());

  text(alph.value(), 20, height - 20);
} // end draw


void mouseReleased() {
  if (!simple.isPlaying()) {
    simple.play();
  }
  else simple.pause();
  if (!simplePV.isPlaying()) {
    if (simplePV.isDone()) {
      simplePV.setEnd(new PVector(random(width), random(height)));
    } 
    simplePV.play();
  }
  else simplePV.pause();
  if (!alph.isPlaying()) {
    if (alph.value() == 255) {
      alph.setEnd(0f);
    }
    else if (alph.value() == 0) {
      alph.setEnd(255f);
    }
    alph.play();
  } 
  else alph.pause();
} // end keyReleased

void keyReleased () {
  if (key == '0') {
    simple.setModeLinear();
    simplePV.setModeLinear();
  } 
  if (key == '1') {
    simple.setModeCubicBoth();
    simplePV.setModeCubicBoth();
  }
  if (key == '2') {
    simple.setModeQuarticBoth();
    simplePV.setModeQuarticBoth();
  }  
  if (keyCode == SHIFT) {
    println(simple);
    println(simplePV);
  }
  if (key == 'r'){
    simple.redirect(mouseX, 220);
  } 
} // end keyReleased

