/**
 * A simple box-like fish.
 * Just swims around following it's heartbeat.
 */
class AGBoxFish extends SuperCreature {
  PMatrix3D mat;
  PVector dimBox, dimR, dimF;
  float fF, fR, aF, aR, fRot, aRot;
  float eye;
  float spd;

  public AGBoxFish() {
    creatureAuthor  = "Andreas Gysin";
    creatureName    = "BoxFish";
    creatureVersion = "Beta";
    setDate(2012, 4, 26); //Y,M,D

    mat = new PMatrix3D();
    mat.rotateY(random(TWO_PI));
    mat.rotateZ(random(-0.1,0.1));

    dimR = new PVector(random(10, 30), random(10, 30));
    dimF = new PVector(random(5, 50), random(5, 20));
    dimBox = new PVector(random(20, 80), random(20, 80), random(15, 40));
    fF = random(0.1, 0.3);
    aF = random(0.6, 1.0);
    fR = random(0.8, 0.9);
    aR = random(0.6, 1.0);
    fRot = fF;//random(0.05, 0.1);
    aRot = random(0.02, 0.05);
    spd = fRot * 10;
    eye = random(1, 3);

  }

  void move() {
    float s = sin(frameCount * fRot);
    mat.rotateY(s * aRot + (noise(pos.z * 0.01, frameCount * 0.01) -0.5) * 0.1);
    mat.rotateZ(s * aRot * 0.3);
    mat.translate(-spd, 0, 0);
    mat.mult(new PVector(), pos);
  }

  void setPos(PVector p) {
    float[] a = mat.get(null);
    a[3] = p.x;
    a[7] = p.y;
    a[11] = p.z;
    mat.set(a);
  }

  void draw() {
    applyMatrix(mat);
    pushMatrix();

    scale(min(getEnergy() * 0.1, 1)); //it's possible to animate a dying creature...
    translate(dimBox.x/4, 0, 0);
    float f = sin(frameCount * fF) * aF;  
    float r = sin(frameCount * fR) * aR;
    float h = sin(frameCount * fF * 0.5 + aF);
    float a = map(h, -1, 1, 20, 100);  
    sphereDetail(5);
    noStroke();
    fill(255, 0, 0, a);
    float hr = dimBox.z * 0.15 + h * dimBox.z * 0.03;
    sphere(hr/2);
    sphere(hr);

    stroke(255);
    noFill();
    box(dimBox.x, dimBox.y, dimBox.z);

    pushMatrix();
    translate(-dimBox.x/2, dimBox.y/2, dimBox.z/2);
    rotateZ(HALF_PI);
    rotateY(f - 1);
    rect(0, 0, dimF.x, dimF.y);
    popMatrix();

    pushMatrix();
    translate(-dimBox.x/2, dimBox.y/2, -dimBox.z/2);
    rotateZ(HALF_PI);
    rotateY(-f + 1);
    rect(0, 0, dimF.x, dimF.y);
    popMatrix();

    pushMatrix();
    translate(dimBox.x/2, dimBox.y/2, dimBox.z/2);
    rotateY(r);
    rect(0, 0, dimR.x, dimR.y);
    popMatrix();

    pushMatrix();
    translate(dimBox.x/2, dimBox.y/2, -dimBox.z/2);
    rotateY(-r);
    rect(0, 0, dimR.x, dimR.y);
    popMatrix();
    
    noStroke();
    fill(255);
    pushMatrix();
    translate(-dimBox.x/2 + eye, dimBox.y/3, -dimBox.z/2);
    sphere(eye);
    translate(0, 0, dimBox.z);
    sphere(eye);
    popMatrix();

    popMatrix();
  }
}

