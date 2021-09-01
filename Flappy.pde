import processing.serial.*;
import cc.arduino.*;

final Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
int buttonState;

public void setup() {
  size(500, 800);
  background(80, 80, 170);
  noStroke();
}

public void draw() {
  grass();
  buttonState = arduino.analogRead(1);
  if (buttonState != 0) {
    jump();
  }
}

public void grass() {
  fill(20, 180, 20);
  rect(0, 700, 500, 700, 500, 800, 0, 800);
}

public void jump() {
  
}
