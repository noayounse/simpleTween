FSTween simple;
PVSTween simplePV;
FSTween live;
CSTween colorTween;
BSTween boolTween;

GenericSTween a;


void setup() {
  size(1000, 500);
  simple = new FSTween(200, 0, (float)width / 8, 7 * (float)width / 8);
  /*
  simple.addNextTarget(100, 30, 100f);
  simple.addNextTarget(200, 100, 400f);
  simple.addNextTarget(40, 100, 200f);
  simple.addNextTarget(200, 30, 600f);
  */

  simplePV = new PVSTween(200, 0, new PVector(0, 0, 0), new PVector(width/2, height/2, 0));

  colorTween = new CSTween(200, 0, color(255, 0, 0), color(0, 255, 0));

  textFont(createFont("Helvetica", 30));
} // end setup

void draw() {
  background(255);

  stroke(0);
  fill(255, 0, 0, 50);
  ellipse(simple.value(), height/2, 20, 20);
  int counter = 0;

  fill(0);
  textSize(12);
  text(simple.value(), simple.value(), height/2 + 20);

  text(nf(mouseX, 0, 2), mouseX, 40);
  text("# of tweens: " + simple.allTweens.size(), 20, 20);


  fill(colorTween.value());
  stroke(0);
  ellipse(simplePV.value().x, simplePV.value().y, 10, 10);
  fill(0);
  noStroke();

text(simplePV.allTweens.size(), simplePV.value().x, simplePV.value().y + 20);
for (int i = 0; i < simplePV.allTweens.size(); i++) {
  //text("is done? " + (simplePV.allTweens.get(i).get(0).isDone()), simplePV.value().x, simplePV.value().y + 30 + i * 20);
  if (simplePV.allTweens.get(i).get(0).influence != null) text(i + " - influence? " + nf((simplePV.allTweens.get(i).get(0).influence.value()), 2, 1), simplePV.value().x, simplePV.value().y + 40 + i * 20);
}
} // end draw


void mouseReleased() {
  simple.playLive(mouseX, 100, 0);
  simplePV.playLive(new PVector(mouseX, mouseY));
  colorTween.playLive(color(random(255), random(255), random(255)));
} // end keyReleased

void keyReleased () {
  if (key == 'p') simple.pause();
  if (key == 'r') simple.resume();
  if (key == 'i') println(simple.isDone());

  if (key == '1') simplePV.setModeLinear();
  if (key == '2') simplePV.setModeCubicBoth();
  if (key == '3') simplePV.setModeQuadBoth();
  if (key == '4') simplePV.setModeQuarticBoth();
  if (key == '5') simplePV.setModeQuintIn();

  if (key == ' ') simplePV.play();
} // end keyReleased

