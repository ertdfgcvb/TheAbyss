private PVector posSceneMouseRef, posEyeMouseRef ;
private PVector posSceneCameraRef, posEyeCameraRef ;
private PVector eyeCamera, sceneCamera ;
private PVector deltaScenePos, deltaEyePos ;
private PVector tempEyeCamera ;
private float getCountZoom ;
private boolean newRefSceneMouse = true ;
private boolean newRefEyeMouse = true ;


void cameraSetup()
{
  sceneCamera = new PVector (width/2 , height/2, 0) ;
  sceneCamera = new PVector (0 , 0, 0) ;
  eyeCamera = new PVector (0,0,0) ;
  //
  posSceneCameraRef = new PVector (0,0,0) ;
  posEyeCameraRef = new PVector (0,0,0) ;
  //
  deltaScenePos = new PVector (0,0,0) ;
  deltaEyePos = new PVector (0,0,0) ;
  //
  tempEyeCamera = new PVector(0,0,0) ;
}

////////////////////////////////
//startCamera with speed setting
void startCamera(boolean scene, boolean eye, float speed)
{
  pushMatrix() ;
  //Move the Scene
  if(scene) {
    //create the ref to calcul the new position of the Scene
    if(newRefSceneMouse) {
      posSceneCameraRef = sceneCamera ;
      posSceneMouseRef = new PVector(mouseX, mouseY) ;
    }
    //to create a only one ref position
    newRefSceneMouse = false ;
    //create the delta between the ref and the mouse position
    deltaScenePos.x = mouseX -posSceneMouseRef.x ;
    deltaScenePos.y = mouseY -posSceneMouseRef.y ;
    sceneCamera = PVector.add(deltaScenePos, posSceneCameraRef ) ;
    /*
    println("delta SCENE " + deltaScenePos);
    println("ref SCNE " + posSceneCameraRef);
    println("SCENE " + sceneCamera) ;
    */
  } else {
    //change the boolean to true for the next mousepressed
    newRefSceneMouse = true ;
  }
    
  
  //move the eye camera
  if(eye) {
    //create the ref to calcul the new position of the Scene
    if(newRefEyeMouse) {
      posEyeCameraRef = tempEyeCamera ;
      posEyeMouseRef = new PVector(mouseX, mouseY) ;
    }
    //to create a only one ref position
    newRefEyeMouse = false ;
    //create the delta between the ref and the mouse position
    deltaEyePos.x = mouseX -posEyeMouseRef.x ;
    deltaEyePos.y = mouseY -posEyeMouseRef.y ;
    tempEyeCamera = PVector.add(deltaEyePos, posEyeCameraRef ) ;
    /*
    println("delta EYE " + deltaEyePos);
    println("ref EYE " + posEyeCameraRef);
    println("EYE " + tempEyeCamera);
    */

    //rotation of the camera
    //solution 1
    /*
    eyeCamera.x = map(tempEyeCamera.y, 0, height, 0, 360) ;
    eyeCamera.y = map(tempEyeCamera.x, 0, width, 0, 360) ;
    */
    //solution 2
    eyeCamera.x += (pmouseY-mouseY) * speed;
    eyeCamera.y += (pmouseX-mouseX) *-speed;
    if(eyeCamera.x > 360 ) eyeCamera.x = 0 ;
    if( eyeCamera.x < 0  ) eyeCamera.x = 360 ;
    if(eyeCamera.y > 360 ) eyeCamera.y = 0 ; 
    if(eyeCamera.y < 0   ) eyeCamera.y = 360 ; 
  } else {
    //change the boolean to true for the next mousepressed
    newRefEyeMouse = true ;
  }
  //zoom
  sceneCamera.z -= getCountZoom ;
  getCountZoom =0 ;
  

  
  camera() ;
  beginCamera() ;

  //scene position
  translate(sceneCamera.x +width/2, sceneCamera.y +height/2, sceneCamera.z) ;
  //eye direction
  // println("Eye " + eyeCamera) ;
  rotateX(radians(eyeCamera.x)) ;
  rotateY(radians(eyeCamera.y)) ;

}
//end camera with speed setting
///////////////////////////////

///////////////////////////////////
//startCamera without speed setting
void startCamera(boolean scene, boolean eye)
{
  pushMatrix() ;
  //Move the Scene
  if(scene) {
    //create the ref to calcul the new position of the Scene
    if(newRefSceneMouse) {
      posSceneCameraRef = sceneCamera ;
      posSceneMouseRef = new PVector(mouseX, mouseY) ;
    }
    //to create a only one ref position
    newRefSceneMouse = false ;
    //create the delta between the ref and the mouse position
    deltaScenePos.x = mouseX -posSceneMouseRef.x ;
    deltaScenePos.y = mouseY -posSceneMouseRef.y ;
    sceneCamera = PVector.add(deltaScenePos, posSceneCameraRef ) ;
    /*
    println("delta SCENE " + deltaScenePos);
    println("ref SCNE " + posSceneCameraRef);
    println("SCENE " + sceneCamera) ;
    */
  } else {
    //change the boolean to true for the next mousepressed
    newRefSceneMouse = true ;
  }
    
  
  //move the eye camera
  if(eye) {
    //create the ref to calcul the new position of the Scene
    if(newRefEyeMouse) {
      posEyeCameraRef = tempEyeCamera ;
      posEyeMouseRef = new PVector(mouseX, mouseY) ;
    }
    //to create a only one ref position
    newRefEyeMouse = false ;
    //create the delta between the ref and the mouse position
    deltaEyePos.x = mouseX -posEyeMouseRef.x ;
    deltaEyePos.y = mouseY -posEyeMouseRef.y ;
    tempEyeCamera = PVector.add(deltaEyePos, posEyeCameraRef ) ;
    /*
    println("delta EYE " + deltaEyePos);
    println("ref EYE " + posEyeCameraRef);
    println("EYE " + tempEyeCamera);
    */

    //rotation of the camera
    //solution 1
    eyeCamera.x = map(tempEyeCamera.y, 0, height, 0, 360) ;
    eyeCamera.y = map(tempEyeCamera.x, 0, width, 0, 360) ;
    //solution 2
    /*
    eyeCamera.x += (pmouseY-mouseY) * speed;
    eyeCamera.y += (pmouseX-mouseX) *-speed;
    if(eyeCamera.x > 360 ) eyeCamera.x = 0 ;
    if( eyeCamera.x < 0  ) eyeCamera.x = 360 ;
    if(eyeCamera.y > 360 ) eyeCamera.y = 0 ; 
    if(eyeCamera.y < 0   ) eyeCamera.y = 360 ; 
    */
  } else {
    //change the boolean to true for the next mousepressed
    newRefEyeMouse = true ;
  }
  //zoom
  sceneCamera.z -= getCountZoom ;
  getCountZoom =0 ;
  

  
  camera() ;
  beginCamera() ;

  //scene position
  translate(sceneCamera.x, sceneCamera.y, sceneCamera.z) ;
  //eye direction
  rotateX(radians(eyeCamera.x)) ;
  rotateY(radians(eyeCamera.y)) ;

}
//UPDATE CAMERA POSITION
void updateCamera(PVector origin, PVector target, float speed)
{
  if(!moveScene) sceneCamera = (follow(origin, target, speed)) ;
  if(!moveEye && gotoTarget) eyeCamera = backEye()  ;
}
//stop
void stopCamera()
{
  popMatrix() ;
  endCamera() ;
}
//END of CAMERA move



//camera draw
void cameraDraw()
{
      //void with speed setting
    float speedRotation = .5 ; // for example 3.0 is very fast, and 0.01 is very slow
    startCamera(moveScene, moveEye, speedRotation) ;
    //to change the scene position with the creature position
    if(gotoTarget) updateCamera(sceneCamera, newTarget, speedMoveOfCamera) ;
}












//CHANGE the position of the CAMERA
///////////////////////////////////
//RAW
void cameraGoto(PVector newPos ) {
  sceneCamera = newPos ;
}


//END of change position of CAMERA
//////////////////////////////////


//GET
PVector getEyeCamera() { return eyeCamera ; }



//ZOOM camera
void zoomCamera(MouseEvent e)
{
  getCountZoom = e.getCount() ;
}
