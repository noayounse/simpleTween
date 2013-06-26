FSTween simple;
PVSTween simplePV;
FSTween live;
CSTween colorTween;
BSTween boolTween;


void setup() {
  size(1000, 500);
  simple = new FSTween(200, 0, (float)width / 8, 7 * (float)width / 8);

  simplePV = new PVSTween(400, 0, new PVector(width/2, height/2), new PVector(width - 50, height - 20));
  simplePV.addNextTarget(new PVector(50, 50), 20, 100);

  live = new FSTween(100, 0, 100, width - 100);
  live.addNextTarget(40f, 200, 50);
  live.addNextTarget(140f, 100, 0);
  live.addNextTarget(240f, 20, 0);
  live.addNextTarget((float)width - 20f, 150, 100);
  
  boolTween = new BSTween(100);

  colorTween = new CSTween(100, 100, color(255, 0, 0), color(0, 255, 255, 30));
  colorTween.addNextTarget(color(0), 100, 40);

  textFont(createFont("Helvetica", 30));
} // end setup

void draw() {
  background(255);

  stroke(0);
  fill(255, 0, 0, 50);
  ellipse(simple.value(), height/2, 20, 20);
  fill(0);
  textSize(12);
  text(simple.percent, simple.value(), height/2 + 20);


  fill(0, 255, 0, 50);
  ellipse(simplePV.value().x, simplePV.value().y, 20, 20);
  fill(0);
  textAlign(CENTER, CENTER);
  text(simplePV.percent, simplePV.value().x, simplePV.value().y);


  fill(colorTween.value());
  noStroke();
  ellipse(live.value(), height / 3, 20, 20);
  fill(0);
  textSize(14);
  text(nf(live.value(), 0, 2), live.value(), height / 3 + 20);
  text(nf(live.getProgress(), 3), live.value(), height / 3 + 30);
  String s = "exists";
  if (live.redirectTween == null) s = "NO EXISTS"; 
  text(s, live.value(), height / 3 + 40);

  fill(0);
  textAlign(LEFT, TOP);
  noStroke();
  text("boolTween progress: " + boolTween.getProgress(), 20, 60);
  text("boolTween duration: " + boolTween.getDuration(), 20, 80);
  text("" + boolTween.value(), 20, 100);
  if (boolTween.fire()){
   live.playLive(mouseX); 
  }
  

  text(nf(mouseX, 0, 2), mouseX, 40);
} // end draw


void mouseReleased() {
  /*
  if (!simple.isPlaying()) {
   simple.play();
   }
   else simple.pause();
   */

  simplePV.playLive(new PVector(mouseX, mouseY));

  //colorTween.playLive(color(random(255), random(255), random(255)));
  colorTween.play();
  
  int randomDelay = (int)random(100);
  println("randomDelay as: " + randomDelay);
  //live.setDelay(randomDelay);
  //live.playLive(mouseX);
  
  boolTween.playLive(10);
} // end keyReleased

void keyReleased () {

  
} // end keyReleased

