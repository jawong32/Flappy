import processing.serial.*;
import cc.arduino.*;
import java.util.Iterator;

Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
int posXCounter = 800;

Bird bird = new Bird(); 

class Shape {
  final int width;
  final int height;
  int posX;
  int posY;
  
  Shape(int width, int height, int posX, int posY) {
    this.width = width;
    this.height = height;
    this.posX = posX;
    this.posY = posY;
  }  

  void render() {
    rect(this.posX, this.posY, this.width, this.height);
  }
}

class Range {
  int startX;
  int stopX;
  int startY;
  int stopY;
  
  Range(int startX, int stopX, int startY, int stopY) {
    this.startX = startX;
    this.stopX = stopX;
    this.startY = startY;
    this.stopY = stopY;
  }

  boolean contains(int valX, int valY) {
    return valX >= this.startX && valX <= this.stopX 
        && valY >= this.startY && valY <= this.stopY;
  }
}

class Bird extends Shape {
  Bird() {
    super(20, 20, 250, 400);
  }
    
  private void fly(boolean buttonState) {
    if (this.posY > 0) {
      this.posY -= buttonState ? 17 : 0;
    }
  }
    
  private void gravity() {
    if (this.posY < 800) {
      this.posY += 5;
    }
  }

  private boolean isCollided() {
    for (Obstacle o: obstacles) {
      if (o.range.contains(this.posX+10, this.posY+10) ||
          o.range.contains(this.posX+10, this.posY-10)) {
        return true;
      } 
    }
    if (this.posY + this.width > 750) {
      return true;
    }
    return false;
  }
    
  void render() {
    fill(255, 255, 0);
    this.gravity();
    ellipse(this.posX, this.posY, 20, 20);
  }
}

class Obstacle extends Shape {
  Range range;

  Obstacle(int height, int posX, int posY) {
    super(50, height+100, posX, posY);
    this.range = new Range(
      posX, posX+50, 
      posY, posY + this.height
    );
    obstacles.add(this);
  }

  private void move() {
    this.posX -= 3;
    this.range = new Range(
      this.posX, this.posX+50, 
      this.posY, this.posY + this.height
    );
  }
  
  void render() {
    fill(0, 100, 0);
    this.move();
    super.render();
  }
}

void setup() {
  size(500, 800);
  noStroke();
}

void draw() {  
  background(80, 80, 170);
  grass();
  createObstacles();
  moveObstacles();
  bird.fly(buttonState());
  bird.render();
  if (bird.isCollided()) noLoop();
}

void grass() {
  fill(20, 180, 20);
  rect(0, 750, 500, 50);
}

void createObstacles() {
  int topHeight = (int) (Math.random() * 370);
  int botHeight = 370 - topHeight;
  obstacles.add(new Obstacle(topHeight, posXCounter, 0));
  obstacles.add(new Obstacle(botHeight, posXCounter, 650 - botHeight));
  posXCounter += 400;
}

void moveObstacles() {
  Iterator<Obstacle> obsItr = obstacles.iterator();
  while (obsItr.hasNext()) {
    Obstacle o = obsItr.next();
    o.render();
    if (o.posX < - 50) {
      obsItr.remove();
    }
  }
}

boolean buttonState() {
  switch (arduino.analogRead(6)) {
    case 1023: return true;
    default: return false;
  }
}
