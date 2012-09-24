/**
 * A floating fish.
 * Position is calculated with Perlin noise.
 */
class AGFloater extends SuperCreature {

  PMatrix3D mat;
  float offset;
  float ampBody, ampWing;
  float freqBody, freqWing;
  float wBody, hBody, wWing;
  float noiseScale, noiseOffset;
  float speedMin, speedMax;

  public AGFloater() {
    creatureAuthor  = "Andreas Gysin";
    creatureName    = "Floater";
    creatureVersion = "Beta";
    setDate(2012, 4, 26); //Y,M,D

    mat = new PMatrix3D();
    mat.rotateY(random(TWO_PI));
    mat.rotateZ(random(-0.2, 0.2));

    freqBody = random(0.1, 0.2);
    freqWing = freqBody;
    offset = 1.2 + random(-0.1,0.2);
    float s = 0.9;
    ampBody = random(10, 30)*s;
    ampWing = random(0.6, 1.2)*s;
    wBody = random(20, 40)*s;
    hBody = random(30, 90)*s;
    wWing = random(20, 50)*s;
    speedMin = random(2.5,3.5)*s;
    speedMax = random(4.5,5.5)*s;
    
    noiseScale = 0.012;
    noiseOffset = random(1); 
  }

  void move() {
    mat.rotateY(map(noise(frameCount * noiseScale + noiseOffset), 0, 1, -0.1, 0.1));
    float speed = map(sin(frameCount * freqBody), -1, 1, speedMin, speedMax);   
    mat.translate(0 , 0, speed);
    mat.mult(new PVector(), pos); //update the position vector
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
    //stroke(255);
    noStroke();
    fill(255);
    rotateX(-HALF_PI);
    scale(min(getEnergy() * 0.1, 1));

    float h1 = sin(frameCount * freqBody) * ampBody;
    float h2 = sin(frameCount * freqWing + offset) * ampWing;

    translate(0, 0, h1);
    rectMode(CENTER);
    rect(0, 0, wBody, hBody);

    rectMode(CORNER);
    pushMatrix();
    translate(-wBody/2, -hBody/2, 0);
    rotateY(PI - h2);
    rect(0, 0, wWing, hBody);
    popMatrix();

    pushMatrix();
    translate(wBody/2, -hBody/2, 0);
    rotateY(h2);
    rect(0, 0, wWing, hBody);
    popMatrix();
  }
}

