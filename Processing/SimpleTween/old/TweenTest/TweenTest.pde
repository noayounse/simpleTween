//FSTween fst;
PVSTween pvst;
CSTween cst;

void setup() {
  size(800, 300);
  //fst = new FSTween(100, 0, 20, width - 20);
  pvst = new PVSTween(100, 100, new PVector(20, 20), new PVector(width/2, height/2));
  cst = new CSTween(100, 0, color(0, 0, 255), color(255, 0, 0));
  /*
  //fst.addNextTarget(100, 30, 100f);
   //fst.addNextTarget(200, 100, 400f);
   //fst.addNextTarget(40, 100, 200f);
   //fst.addNextTarget(200, 30, 600f);
   */
} // end setup


void draw() {
  background(255);
  fill(255, 0, 0);
  //ellipse(fst.value(), height / 2, 20, 20);
  textAlign(CENTER);
  fill(0);

  fill(cst.value());
  ellipse(pvst.value().x, pvst.value().y, 20, 20);
} // end draw


void mouseReleased() {  
  //fst.playLive(mouseX);
  pvst.playLive(new PVector(mouseX, mouseY), 100, 0);
  cst.playLive(color(random(255), random(255), random(255)));
} // end mouseReleased


void keyReleased() {
  if (key == 'p') {
    pvst.play();
    //fst.play();
    cst.play();
  }
  if (key == ' ') {
    if (pvst.isPaused()) {
      pvst.play();
      //fst.play();
      cst.play();
    }
    else {
      pvst.pause();
      //fst.pause();
      cst.pause();
    }
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
  if (key == '1') pvst.setModeLinear();
  if (key == '2') pvst.setModeCubicBoth();
  if (key == '3') pvst.setModeQuadBoth();
  if (key == '4') pvst.setModeQuarticBoth();
  if (key == '5') pvst.setModeQuintIn();
  if (key == 'd') println(pvst.getDelay());

  if (key == 'l') {
    pvst.addNextTarget(new PVector(mouseX, mouseY));
    //fst.addNextTarget(100, 0, mouseX);
  }
} // end keyReleased

// to do: delay, pause, next

