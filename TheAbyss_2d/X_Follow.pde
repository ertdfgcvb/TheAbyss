

//INIT FOLLOW
float distFollowRef = 0 ;
PVector eyeBackRef = new PVector(0,0,0 ) ;

void initFollow() {
  absPosition = new PVector(0,0,0) ;
  gotoTarget = true ;
}

void initFollow(PVector target, PVector eye) {
  distFollowRef = PVector.dist(target, sceneCamera) ;
  //println(distFollowRef) ;
  //println(targetName) ;
  eyeBackRef = eye ;
  absPosition = new PVector(0,0,0) ;
  gotoTarget = true ;
}
//END INIT FOLLOW


PVector backEye()
{
  PVector eye = new PVector(0,0) ;
  if(eyeBackRef.x < 180 ) eye.x = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.x, 0) ; else eye.x = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.x, 360) ;
  if(eyeBackRef.y < 180 ) eye.y = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.y, 0) ; else eye.y = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.y, 360) ;
  //println(currentDistToTarget, distFollowRef, eye) ;
  println("Eye " + eye, "Eye Ref " + eyeBackRef) ;
  // eye.x = map(currentDistToTarget,0,distFollowRef,0,eyeBackRef.x) ;
  // eye.y = map(currentDistToTarget,0,distFollowRef,0,eyeBackRef.y) ;
  return eye ;
}


//MAIN VOID
PVector speedByAxes = new PVector(0,0,0) ;
boolean gotoTarget ;
//
/*
void cameraGoto(PVector newPos, float speed) {
  cameraSpeedMove = speed ;
  newDistanceToTarget = new PVector(0,0,0) ;
  distToCamera = PVector.sub(sceneCamera, newPos) ;
  speedByAxes = PVector.div(distToCamera, 1.0 / speed) ;
  // println(distToCamera, speedByAxes ) ;
}
*/
//calculate new position to go at the new target camera
PVector distToTargetUpdated = new PVector (0,0,0) ;
float currentDistToTarget = 0 ;
PVector currentPosition = new PVector(0,0,0) ;
PVector absPosition = new PVector(0,0,0) ;
// PVector targetPoint ;

PVector follow(PVector origin, PVector target, float speed)
{
  //very weird I must inverse the value to have the good result !
  //and change again at the end of the algorithm
  target.x = -target.x ;
  target.y = -target.y ;
  target.z = -target.z ;
  
  //updated the distance in realtime
  distToTargetUpdated = PVector.sub(currentPosition, target) ;
  currentDistToTarget = PVector.dist(currentPosition, target) ;
  
  
  //calculate the speed to go to target
  PVector absValueOfDist = new PVector (abs(distToTargetUpdated.x),abs(distToTargetUpdated.y),abs(distToTargetUpdated.z));
  absValueOfDist.normalize() ;
  //speedByAxes = PVector.div(absValueOfDist, 1.0 / speed) ; 
  speedByAxes = PVector.mult(absValueOfDist, speed) ;
  // println(speedByAxes.x, distToTargetUpdated.x, distToTargetUpdated.x / speedByAxes.x ) ;
  // PVector rangeStop = PVector.mult(speedByAxes,5000) ;
  PVector rangeStop = new PVector(5,5,5) ; 
  //calculate the new absolute position

  //XYZ
  if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x) && 
        (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y) && 
        (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //XY  
  } else if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x) && 
              (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y)) {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    absPosition.z += 0 ;
  //XZ
  } else if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x) && 
              (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    absPosition.y += 0 ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //YZ
  } else if ( (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y) && 
              (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    absPosition.x += 0 ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //X
  } else if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x)) {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    absPosition.y += 0 ;
    absPosition.z += 0 ;
  //Y  
  } else if ( (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y))  {
    absPosition.x += 0 ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    absPosition.z += 0 ;
  //Z
  } else if ( (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    absPosition.x += 0 ;
    absPosition.y += 0 ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //IT'S DONE, NOTHING TO DO NOW
  } else {  
    absPosition.x += 0 ;
    absPosition.y += 0 ;
    absPosition.z += 0 ;
    gotoTarget = false ;
  }
  
  //very weird I must inverse the value to have the good result !
  target.x = -target.x ;
  target.y = -target.y ;
  target.z = -target.z ;


  //finalize the newposition of the point
  currentPosition = PVector.add(origin, absPosition) ;
  /*
  currentPosition.x = origin.x + absPosition.x  ; 
  currentPosition.y = origin.y + absPosition.y ; 
  currentPosition.z = origin.z + absPosition.z  ; 
  */
  /*
  println("         Origine " + origin  ) ;
  println("       Final Pos " + currentPosition  ) ;
  println("          Target " + target) ;
  */
  //println("        Distance " + distToTarget ) ;
  //println("Distance updated " + distToTargetUpdated ) ;
  // println("         Vitesse " + speedByAxes ) ;
  
  return currentPosition ;
}
