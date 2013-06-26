class Ball {
  FSTween rad;
  PVSTween pv;
  CSTween c;

  Ball() {
    rad = new FSTween(200, 0, 24f, 0f);
    pv = new PVSTween(200, 0, new PVector(0, 0, 0), new PVector(width/2, height/2));
    c = new CSTween(100, 50, color(255, 127, 0), color(0, 255, 255));
  } // end constructor

  void display() {
    stroke(255, 0, 0);
    fill(c.value());
    ellipse(pv.value().x, pv.value().y, rad.value(), rad.value());
  } // end display
} // end class Ball

