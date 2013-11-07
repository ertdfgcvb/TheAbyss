


/**
 * The Abyss by Andreas Gysin
 * Rework camera and little thing from Stanislas Marçais
 * 2010-13
 */
//color setting
color noir, rouge, blanc ;
//CAMERA Stuff
boolean moveScene, moveEye ;
PVector newTarget = new PVector(0, 0, 0) ;
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
  //camera order
  if(mouseButton == LEFT) moveScene = true ; 
  if(mouseButton == RIGHT) moveEye = true ; 
  if(!mousePressed) { moveScene = false ; moveEye = false ; }
  
  
  //
  creatureManager.loop(blanc);
}

void mouseWheel(MouseEvent event)
{
  zoomCamera(event) ;
}

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



void capture() {
  save("snaps/" + System.currentTimeMillis() + ".png");
}


//FULLSCREEN
boolean sketchFullScreen() {
  return true ;
}
