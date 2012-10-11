/**
 * The Abyss
 * 2012
 */

import processing.opengl.*;
import java.lang.reflect.*;

// Fog and backdrop could be integrated in the creaturemanager... 
// but it's also ok to keep the "decorations" outside of it.
Fog fog; 
CreatureManager creatureManager;
boolean useBackdrop = false;

void setup() {
  size(screenWidth, screenHeight, OPENGL);  
  hint(ENABLE_OPENGL_4X_SMOOTH);
  hint(DISABLE_OPENGL_ERROR_REPORT); 
  frameRate(60);
  creatureManager = new CreatureManager(this);
  fog = new Fog(this, 800, 2000, color(0, 40, 60));
}

void draw() {
  background(0);
  if (useBackdrop) drawBackdrop();
  creatureManager.draw();
}

void mouseDragged() {
  PVector v = creatureManager.getCamera().getCameraControl();
  v.x += (pmouseX - mouseX) * 0.01;
  v.y = constrain(v.y - (pmouseY - mouseY) * 5.0, 300, 10000);
  creatureManager.getCamera().setCameraControl(v);
}

void mousePressed() {
  creatureManager.getCamera().setCameraMode(CreatureCamera.DEFAULT_CAM);
}

void keyPressed() { 
  if (key == ' ')            creatureManager.addCurrentCreature();
  else if (keyCode == RIGHT) creatureManager.selectNextCreature();
  else if (keyCode == LEFT)  creatureManager.selectPrevCreature();
  else if (keyCode == UP)    creatureManager.nextCameraCreature();
  else if (keyCode == DOWN)  creatureManager.prevCameraCreature();
  else if (keyCode == ENTER) creatureManager.currentCameraCreature();
  else if (key == 'b')       useBackdrop = !useBackdrop;
  else if (key == 'o')       creatureManager.toggleAbyssOrigin();
  else if (key == 'h')       creatureManager.toggleManagerInfo();
  else if (key == 'i')       creatureManager.toggleCreatureInfo();
  else if (key == 'a')       creatureManager.toggleCreatureAxis();
  else if (key == 'r')       creatureManager.addRandomCreature();
  else if (key == 'x')       creatureManager.killAll();
  else if (key == 's')       capture();
}

void drawBackdrop(){
  pushMatrix();
  noStroke();
  translate(width/2, height/2);
  rotateZ(sin(frameCount*0.001)*TWO_PI);
    
  float h = dist(0,0,width,height);
  float b1 = map(sin(frameCount*0.013),-1,1,0,1);
  float b2 = map(sin(frameCount*0.017),-1,1,0,1);    
  float b3 = map(sin(frameCount*0.019),-1,1,0,1);
    
  beginShape(QUAD_STRIP);
  fill(0, b1*40, b1*60); vertex(-h, -h);
  fill(0, b1*40, b1*60); vertex( h, -h);
  fill(0, b2*40, b2*60); vertex(-h,  0);
  fill(0, b2*40, b2*60); vertex( h,  0);
  fill(0, b3*40, b3*60); vertex(-h,  h);
  fill(0, b3*40, b3*60); vertex( h,  h);
  endShape();
  popMatrix();
}

void capture(){
   saveFrame("snap_" + System.currentTimeMillis() + ".png"); 
}

