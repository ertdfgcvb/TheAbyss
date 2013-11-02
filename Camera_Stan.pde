PVector posSceneMouseRef, posEyeMouseRef ;
PVector posSceneCameraRef, posEyeCameraRef ;
PVector eyeCamera, sceneCamera ;
PVector deltaScenePos, deltaEyePos ;
PVector tempEyeCamera ;
float getCountZoom ;
boolean newRefSceneMouse = true ;
boolean newRefEyeMouse = true ;

void cameraSetup()
{
  sceneCamera = new PVector (width/2 , height/2, 0) ;
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


void startCamera()
{
  //Move the Scene
  if(mouseButton == LEFT) {
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
        println("delta SCENE " + deltaScenePos);
    println("ref SCNE " + posSceneCameraRef);
    println("SCENE " + sceneCamera) ;
  } else {
    //change the boolean to true for the next mousepressed
    newRefSceneMouse = true ;
  }
    
  
  //move the eye camera
  if(mouseButton == RIGHT) {
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
    println("delta EYE " + deltaEyePos);
    println("ref EYE " + posEyeCameraRef);
    println("EYE " + tempEyeCamera);

    //rotation of the camera
    eyeCamera.x = map(tempEyeCamera.y, 0, height, 0, 360) ;
    eyeCamera.y = map(tempEyeCamera.x, 0, width, 0, 360) ;
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

void zoomCamera(MouseEvent e)
{
  getCountZoom = e.getCount() ;
}
