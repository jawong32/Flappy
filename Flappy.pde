import processing.serial.*;
import cc.arduino.*;

Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

Bird bird = new Bird(); 
Obstacle topOne = new Obstacle(450, 0);
Obstacle bottomOne = new Obstacle(450, 550);
Obstacle topTwo = new Obstacle(700, 0);
Obstacle bottomTwo = new Obstacle(700, 550);

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

  private void checkCollision() {
    for (Obstacle o: obstacles) {
      if (o.range.contains(this.posX, this.posY)) {
        noLoop();
      } 
    }
  }
    
  void render() {
    fill(255, 255, 0);
    this.gravity();
    ellipse(this.posX, this.posY, 20, 20);
  }
}

class Obstacle extends Shape {
  private final int origX;
  Range range;

  Obstacle(int posX, int posY) {
    super(50, 200, posX, posY);
    this.origX = posX;
    this.range = new Range(posX, posX+50, posY, posY+200);
    obstacles.add(this);
  }

  private void move() {
    this.posX -= 5;
    if (this.posX < -50) {
      this.posX = this.origX;
    }
    this.range = new Range(
      this.posX, this.posX+50, this.posY, this.posY+200
    );
  }
  
  void render() {
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
  obstacles();
  bird.fly(buttonState());
  bird.render();
  bird.checkCollision();
}

void grass() {
  fill(20, 180, 20);
  rect(0, 750, 500, 50);
}

void obstacles() {
  fill(0, 100, 0);
  for (Obstacle o: obstacles) o.render();
}

boolean buttonState() {
  switch (arduino.analogRead(6)) {
    case 1023: return true;
    default: return false;
  }
}
