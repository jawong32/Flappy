import processing.serial.*;
import cc.arduino.*;

Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
ArrayList<Object> obstacles = new ArrayList<Object()>;

Bird bird = new Bird(); 
Pipe topOne = new Pipe(450, 0);
Pipe bottomOne = new Pipe(450, 550);
Pipe topTwo = new Pipe(700, 0);
Pipe bottomTwo = new Pipe(700, 550);

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
    
  void render() {
    fill(255, 255, 0);
    this.gravity();
    ellipse(this.posX, this.posY, 20, 20);
  }
}

class Pipe extends Shape {
  private final int origX;

  Pipe(int posX, int posY) {
    super(50, 200, posX, posY);
    this.origX = posX;
    obstacles.add(this);
  }

  private void move() {
    this.posX -= 5;
    if (this.posX < -50) {
      this.posX = this.origX;
    }
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
  pipes();
  bird.fly(buttonState());
  bird.render();  
}

void grass() {
  fill(20, 180, 20);
  rect(0, 750, 500, 50);
}

void pipes() {
  topOne.render();
  topTwo.render();
  bottomOne.render();
  bottomTwo.render();
}

boolean buttonState() {
  switch (arduino.analogRead(6)) {
    case 1023: return true;
    default: return false;
  }
}
