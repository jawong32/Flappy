import processing.serial.*;
import cc.arduino.*;

Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
Bird bird = new Bird(); 

public class Bird {
    final int posX = 250;
    int posY = 400;
    
    private fly(boolean buttonState) {
        int posY += 20 ? buttonState : 0;
    }
    
    private draw() 
        fill(255, 255, 0);
        ellipse(this.posX, this.posY, 20, 20);
    }
}

public void setup() {
  size(500, 800);
  noStroke();
}

public void draw() {
  background(80, 80, 170);
  grass();
  bird.fly(isPressed());
}

public void boolean buttonState() {
    switch (arduino.analogRead(6)) {
        case 0: return false;
        case 1023: return true;
    }
}

public void grass() {
  fill(20, 180, 20);
  rect(0, 700, 500, 100);
}
