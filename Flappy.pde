import processing.serial.*;
import cc.arduino.*;

Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
Bird bird = new Bird(); 
Pipe topOne = new Pipe(450, 0);
Pipe bottomOne = new Pipe(450, 550);
Pipe topTwo = new Pipe(700, 0);
Pipe bottomTwo = new Pipe(700, 550);

class Shape {
  private final int width;
  private final int length;
  private int posX;
  private int posY;
  
  public Shape(int width, int length, int x, int y) {
    this.width = width;
    this.length = length;
    this.posX = x;
    this.posY = y;
  }  
}

class Bird {
  private final int posX = 250;
  private int posY = 400;
    
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
    
  private void render() {
    fill(255, 255, 0);
    this.gravity();
    ellipse(this.posX, this.posY, 20, 20);
  }
}

class Pipe {
  private final int width = 50;
  private final int length = 200;
  private int posX;
  private int posY;
  private int ogX;
  
  private Pipe(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
    this.ogX = posX;
  }
  
  private void move() {
    this.posX -= 5;
    if (this.posX < -50) this.posX = this.ogX;
  }
  
  private void render() {
    fill(0, 100, 0);
    this.move();
    rect(this.posX, this.posY, this.width, this.length);
  }
}

void setup() {
  size(500, 800);
  noStroke();
}

void draw() {
  background(80, 80, 170);
  topOne.render();
  bottomOne.render();
  topTwo.render();
  bottomTwo.render();
  grass();
  bird.fly(buttonState());
  bird.render();  
}

void grass() {
  fill(20, 180, 20);
  rect(0, 750, 500, 50);
}

boolean buttonState() {
  switch (arduino.analogRead(6)) {
    case 1023: return true;
    default: return false;
  }
}
