import processing.serial.*;
import cc.arduino.*;

final Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
int buttonState;

public void setup() {
  size(500, 800);
}

public void draw() {
  buttonState = arduino.analogRead(1);
  if (buttonState != 0) {
    jump();
  }
}

public void jump() {
  
}
