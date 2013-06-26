STween simple;
PVSTween simplePV;
STween live;
CSTween colorTween;


void setup() {
  size(1000, 500);
  simple = new STween(200f, 0f, (float)width / 8, 7 * (float)width / 8);
  simplePV = new PVSTween(300f, 0f, new PVector(width/2, height/2), new PVector(width - 50, height - 20));

  live = new STween(300f, 0f, 100, width - 100);
  
  colorTween = new CSTween(200f, 50f, color(255, 0, 0), color(0, 255, 255, 30));

  textFont(createFont("Helvetica", 30));
} // end setup

void draw() {
  background(255);

  stroke(0);
  fill(255, 0, 0, 50);
  ellipse(simple.valueST(), height/2, 20, 20);
  fill(0);
  textSize(12);
  text(simple.percent, simple.valueST(), height/2 + 20);


  fill(0, 255, 0, 50);
  ellipse(simplePV.valuePVector().x, simplePV.valuePVector().y, 20, 20);
  fill(0);
  textAlign(CENTER, CENTER);
  text(simplePV.percent, simplePV.valuePVector().x, simplePV.valuePVector().y);

  fill(colorTween.valueColor());
  noStroke();
  ellipse(live.valueST(), height / 3, 20, 20);
} // end draw


void mouseReleased() {
  if (!simple.isPlaying()) {
    simple.play();
  }
  else simple.pause();

  simplePV.playLive(new PVector(mouseX, mouseY));

  colorTween.play();

  live.playLive(mouseX);
} // end keyReleased

void keyReleased () {
} // end keyReleased

