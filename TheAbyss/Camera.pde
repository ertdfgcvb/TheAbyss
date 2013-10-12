/**
 * A simple camera class.
 * And its Creature Camera extension.
 */
class Camera {
  PVector eye, lookAt, up;
  private float fov = PI/3;
  float near = 0.001;
  float far = 1000;
  float cameraZ;

  Camera(PVector eye, PVector lookAt, PVector up, float fov) {
    this.eye = eye;
    this.lookAt = lookAt;
    this.up = up;
    setFov(fov);
  }

  Camera() {
    this(new PVector(0, 0, 0), new PVector(0, 0, -1), new PVector(0, 1, 0), PI/3);
  }

  void print() {
    println("-- CAMERA ---------------");
    println("eye: ");
    println("x = " + eye.x);
    println("y = " + eye.y);
    println("z = " + eye.z);    
    println("");
    println("lookAt: ");
    println("x = " + lookAt.x);
    println("y = " + lookAt.y);
    println("z = " + lookAt.z);
  }

  void setFov(float fov) {
    this.fov = fov;
    cameraZ = (height/2.0) / tan(fov/2.0);
  }

  void apply() {
    perspective(fov, float(width)/float(height), cameraZ*near, cameraZ*far);
    camera(eye.x, eye.y, eye.z, lookAt.x, lookAt.y, lookAt.z, up.x, up.y, up.z);
  }

  void debug() {
    sphereDetail(10);

    //eye
    pushMatrix();
    translate(eye.x, eye.y, eye.z);
    noStroke();
    fill(0);
    sphere(10);
    popMatrix();

    //lookAt
    pushMatrix();
    translate(lookAt.x, lookAt.y, lookAt.z);
    noStroke();
    fill(0);
    sphere(5);
    popMatrix();

    stroke(0);
    line(eye.x, eye.y, eye.z, lookAt.x, lookAt.y, lookAt.z);
  }
}

class CreatureCamera extends Camera {
  final static int DEFAULT_CAM    = 0;
  final static int CREATURE_CAM   = 1;
  final static int AUTOROTATE_CAM = 2;

  int cameraMode = DEFAULT_CAM;
  float eyeDamp = 0.1;
  float lookAtDamp = 0.1;  
  SuperCreature targetCreature;
  PVector dLookAt, dEye;
  float creatureDist = 500;
  float angle, radius;

  CreatureCamera() {
    super(); 
    dLookAt = lookAt.get();
    dEye = eye.get();    
    setRadius(1000);
    setAngle(0);
  }

  float getAngle() {
    return angle;
  }

  void setAngle(float a) {
    angle = a;
    dEye.x = dLookAt.x + sin(angle) * radius;
    dEye.z = dLookAt.y + cos(angle) * radius;
  }

  void setRadius(float r) {
    radius = r;
    dEye.x = dLookAt.x + sin(angle) * radius;
    dEye.z = dLookAt.y + cos(angle) * radius;
  }

  void apply() {
    if (targetCreature == null || targetCreature.getEnergy() <= 0) {
      cameraMode = DEFAULT_CAM;
    }
    
    if (cameraMode == DEFAULT_CAM || cameraMode == AUTOROTATE_CAM) {      
      if ( cameraMode == AUTOROTATE_CAM) {
        angle += 0.007;
      }
      // some extra floating motion:
      float x = cos(frameCount * 0.001 + angle) * radius;
      float y = sin(frameCount * 0.004) * 200;
      float z = sin(frameCount * 0.001 + angle) * radius;    
      dEye.set(x, y, z);
      dLookAt.set(0, 0, 0);
    } 
    else if (cameraMode == CREATURE_CAM) {
      dLookAt.set(targetCreature.getPos());      
      PVector v = PVector.sub(eye, dLookAt);
      v.normalize();
      v.mult(creatureDist);
      dEye = PVector.add(dLookAt, v);
    }
    interpolate();
    super.apply();
  }

  void setTargetCreature(SuperCreature c) {
    targetCreature = c;
  }

  void setCameraMode(int mode) {
    cameraMode = mode;
  }

  void interpolate() {
    lookAt.x += (dLookAt.x - lookAt.x) * lookAtDamp;
    lookAt.y += (dLookAt.y - lookAt.y) * lookAtDamp;
    lookAt.z += (dLookAt.z - lookAt.z) * lookAtDamp;    
    eye.x += (dEye.x - eye.x) * eyeDamp;
    eye.y += (dEye.y - eye.y) * eyeDamp;
    eye.z += (dEye.z - eye.z) * eyeDamp;
  }

  float eyeDist(PVector v) {
    return dist(eye.x, eye.y, eye.z, v.x, v.y, v.z);
  }
}

