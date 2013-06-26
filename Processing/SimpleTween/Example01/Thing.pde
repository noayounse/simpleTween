class Thing {
  float duration = random(80, 120);
  float delay = random(0, 50);
  PVSTween pos = new PVSTween(duration, delay, new PVector(), new PVector());
  CSTween c = new CSTween(duration, delay, 0, 0);
  FSTween rad = new FSTween(duration, delay, 0, random(10, 20));
  int conception = 0;
  
  Thing () {
    pos.setBegin(new PVector(random(-200, 200), random(-200, 200), random(-200, 200)));
    c.setBegin(color(random(255), random(255), random(255)));
    rad.play();
    conception = frameCount;
  } // end constructor
  
  void display() {
    fill(c.value());
    noStroke();
    pushMatrix();
    translate(pos.value().x, pos.value().y, pos.value().z);
    //sphere(rad.value());
    rectMode(CENTER);
    rect(0, 0, rad.value(), rad.value());
    popMatrix();
    //ellipse(pos.value().x, pos.value().y, rad.value(), rad.value());
    //rectMode(CENTER);
    //rect(pos.value().x, pos.value().y, rad.value(), rad.value());
  } // end display 
  
  void makeNewPos(PVector newPos) {
    pos.playLive(newPos);
    c.playLive(color(random(255), random(255), random(255)));
    rad.playLive(random(10, 20));
  } // end makeRandomPos
  
  void setMode(int modeIn) {
    pos.setMode(modeIn);
    c.setMode(modeIn);
    rad.setMode(modeIn);
  } 
  
  boolean okToDie() {
    if (rad.value() == 0 && frameCount > conception + delay) return true;
    return false;
  } // end okToDie
} // end class Thing
