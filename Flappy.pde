import processing.serial.*;
import cc.arduino.*;

Arduino arduino = new Arduino(this, Arduino.list()[0], 56700);
Bird bird = new Bird(); 

public class Bird {
    private final int posX = 250;
    private int posY = 400;
    
    private void fly(boolean buttonState) {
        this.posY += 20 ? buttonState : 0;
    }
    
    private void gravity() {
        this.posY -= 10;
    }
    
    private void draw() 
        fill(255, 255, 0);
        this.gravity();
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
  bird.draw();
}

public boolean buttonState() {
    switch (arduino.analogRead(6)) {
        case 0: return false;
        case 1023: return true;
    }
}

public void grass() {
  fill(20, 180, 20);
  rect(0, 700, 500, 100);
}
