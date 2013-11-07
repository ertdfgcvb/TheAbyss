


/**
 * The Abyss by Andreas Gysin
 * Rework camera and little thing by Stan le Punk
 * 2010-13
 */
//color setting
color noir, rouge, blanc ;

//speed must be 1 or less
float speedMoveOfCamera = 0.1 ;

//THE ABYSS
CreatureManager creatureManager;
boolean useBackdrop = false;

void setup() {
  size(displayWidth, displayHeight, P3D);
  colorMode(HSB,360,100,100) ;
  //setting color
  noir = color(0,100,0) ;
  rouge = color(10, 100, 75) ;
  blanc = color(0,0,100) ;  

  creatureManager = new CreatureManager(this);


  //camera
  cameraSetup() ;
} 

void draw() { 
  noCursor();

  if (keyPressed && key == ' ' && frameCount % 4 == 0) {
    creatureManager.addCurrentCreature();
  }
  //background scene
  int opacity = 70 ;
  //two parameters the first is color, the second is the opacity
  backgroundP3D(rouge, opacity) ;

  //CAMERA
  cameraDraw() ;
  //
  creatureManager.loop(blanc);
  //stop camera
  stopCamera() ;
}


//CAMERA

//CAMERA Stuff
boolean moveScene, moveEye ;
PVector newTarget = new PVector(0, 0, 0) ;
//MOUSE WHEEL ZOOM
void mouseWheel(MouseEvent event)
{
  zoomCamera(event) ;
}
//camera draw
void cameraDraw()
{
  //camera order
  if(mouseButton == LEFT) moveScene = true ; 
  if(mouseButton == RIGHT) moveEye = true ; 
  if(!mousePressed) { moveScene = false ; moveEye = false ; }
  //void with speed setting
  float speedRotation = .5 ; // for example 3.0 is very fast, and 0.01 is very slow
  startCamera(moveScene, moveEye, speedRotation) ;
  //to change the scene position with the creature position
  if(gotoTarget) updateCamera(sceneCamera, newTarget, speedMoveOfCamera) ;
}
//END CAMERA


//KEYPRESSED
void keyReleased() {
  if (keyCode == RIGHT)      creatureManager.selectNextCreature();
  else if (keyCode == LEFT)  creatureManager.selectPrevCreature();
  else if (keyCode == UP)    creatureManager.nextCameraCreature();
  else if (keyCode == DOWN)  creatureManager.prevCameraCreature();  
  else if (key == 'o')       creatureManager.toggleAbyssOrigin();
  else if (key == 'h')       creatureManager.toggleManagerInfo();
  else if (key == 'i')       creatureManager.toggleCreatureInfo();
  else if (key == 'a')       creatureManager.toggleCreatureAxis();
  else if (key == 'r')       creatureManager.addRandomCreature();
  else if (key == 'x')       creatureManager.killAll();
  else if (key == 's')       capture();  
}


//CAPTURE
void capture() {
  save("snaps/" + System.currentTimeMillis() + ".png");
}


//FULLSCREEN
boolean sketchFullScreen() {
  return true ;
}
