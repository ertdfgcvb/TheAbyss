/**
 * The Abyss
 * 2010-13
 */

CreatureManager creatureManager;
boolean useBackdrop = true;

void setup() {
  size(displayWidth, displayHeight, P3D);  
  smooth(8);
  frameRate(60);
  creatureManager = new CreatureManager(this);
  // creatureManager.toggleManagerInfo(); // turn info off

  initShaders();
  //camera
  cameraSetup() ;
} 

void draw() { 
  noCursor();

  if (keyPressed && key == ' ' && frameCount % 4 == 0) {
    creatureManager.addCurrentCreature();
  }

  background(0);
  
  
  //
  if (useBackdrop) drawBackdrop();
  creatureManager.loop();
  //
  endCamera() ;
  
}

void mouseWheel(MouseEvent event)
{
  zoomCamera(event) ;
}
/*
void mouseDragged() {
  CreatureCamera cam = creatureManager.getCamera();
  float ang = cam.getAngle() + (pmouseX - mouseX) * 0.006;
  float rad = map(mouseY, 0, height, 300, 7000);
  cam.setAngle(ang);
  cam.setRadius(rad);
}
*/
/*
void mousePressed() {
  creatureManager.getCamera().setCameraMode(CreatureCamera.DEFAULT_CAM);
}
*/
void keyReleased() {
  if (keyCode == RIGHT)      creatureManager.selectNextCreature();
  else if (keyCode == LEFT)  creatureManager.selectPrevCreature();
  else if (keyCode == UP)    creatureManager.nextCameraCreature();
  else if (keyCode == DOWN)  creatureManager.prevCameraCreature();  
  else if (key == 'b')       useBackdrop = !useBackdrop;
  else if (key == 'o')       creatureManager.toggleAbyssOrigin();
  else if (key == 'h')       creatureManager.toggleManagerInfo();
  else if (key == 'i')       creatureManager.toggleCreatureInfo();
  else if (key == 'a')       creatureManager.toggleCreatureAxis();
  else if (key == 'r')       creatureManager.addRandomCreature();
  else if (key == 'x')       creatureManager.killAll();
  else if (key == 's')       capture();  
  else if (key == 'c')       {
    /*
    CreatureCamera cam = creatureManager.getCamera();  
    cam.setCameraMode(CreatureCamera.AUTOROTATE_CAM);
    cam.setRadius(3000);
    */
  }
}

void drawBackdrop() {
  // TODO: solve with a shader...
  pushMatrix();
  noStroke();
  translate(width/2, height/2);
  rotateZ(sin(frameCount*0.001)*TWO_PI);

  float h = dist(0, 0, width, height);
  float b1 = map(sin(frameCount*0.013), -1, 1, 0.2, 1);
  float b2 = map(sin(frameCount*0.017), -1, 1, 0.2, 1);    
  float b3 = map(sin(frameCount*0.019), -1, 1, 0.2, 1);
  float r = 0;
  float g = 30;
  float b = 70;

  beginShape(QUAD_STRIP);
  fill(r, b1*g, b1*b); 
  vertex(-h, -h);
  fill(r, b1*g, b1*b); 
  vertex( h, -h);
  fill(r, b2*g, b2*b); 
  vertex(-h, 0);
  fill(r, b2*g, b2*b); 
  vertex( h, 0);
  fill(r, b3*g, b3*b); 
  vertex(-h, h);
  fill(r, b3*g, b3*b); 
  vertex( h, h);
  endShape();
  popMatrix();
}

void initShaders() {
  PShader fogColor = loadShader("fogColor.glsl");
  fogColor.set("fogNear", 400.0); 
  fogColor.set("fogFar", 3500.0);
  fogColor.set("fogColor", 0.0, 0.15, 0.23);

  PShader fogLines = loadShader("fogLines.glsl");
  fogLines.set("fogNear", 400.0); 
  fogLines.set("fogFar", 3500.0);
  fogLines.set("fogColor", 0.0, 0.15, 0.23);

  shader(fogColor, TRIANGLES);
  shader(fogLines, LINES);
}

void capture() {
  save("snaps/" + System.currentTimeMillis() + ".png");
}
