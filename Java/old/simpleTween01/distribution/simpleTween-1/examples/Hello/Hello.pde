import simpleTween.*;

SimpleTween st;
BSTween trigger;

Ball ball;

ArrayList<Ball> balls;

void setup() {
  size(400, 400);
  smooth();

  st = new SimpleTween(this);
  trigger = new BSTween(1);

  ball = new Ball();
  balls = new ArrayList<Ball>();
  for (float xPos = ball.rad.value(); xPos < width; xPos += 1.25 * ball.rad.value()) {
    for (float yPos = ball.rad.value(); yPos < height; yPos += 1.25 * ball.rad.value()) {  
      Ball newBall = new Ball();
      PVector newPos = new PVector(xPos, yPos);
      newBall.pv.setBegin(newPos);
      newBall.c.setBegin(color(random(255), random(255), random(255)));
      balls.add(newBall);
    }
  }
} // end setup

void draw() {
  background(0);
  fill(255);
  if (trigger.fire()) go();
  for (Ball b : balls) b.display();
  ball.display();
}

void mouseReleased() {
  trigger.play();
  loadPixels();
  ball.c.playLive(get(mouseX, mouseY));
  ball.pv.playLive(new PVector(mouseX, mouseY));
  ball.rad.playLive(random(5, 50));
} // end mouseReleased

void go() {
} // end go

