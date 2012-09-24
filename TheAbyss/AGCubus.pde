class AGCubus extends SuperCreature {

  PVector freqMulPos, freqMulAng;
  float cSize;
  float bLen;
  float aFreq;
  float bOffs;
  float angRange;

  public AGCubus() {
    creatureAuthor  = "Andreas Gysin";
    creatureName    = "Cubus";
    creatureVersion = "Beta";
    setDate(2012, 4, 22); //Y,M,D

    cSize = random(6, 30);
    bLen = random(4, 10);
    aFreq = random(0.01, 0.1);
    bOffs = random(5);
    angRange = random(0.3, 0.6);
    freqMulPos = new PVector(random(-0.002, 0.002), random(-0.002, 0.002), random(-0.002, 0.002));
    freqMulAng = new PVector(random(-0.005, 0.005), random(-0.005, 0.005), random(-0.005, 0.005));
  }

  void move() {
    pos.x += sin(frameCount*freqMulPos.x);
    pos.y += sin(frameCount*freqMulPos.y);
    pos.z += cos(frameCount*freqMulPos.y);

    rot.x = sin(frameCount*freqMulAng.x) * TWO_PI;
    rot.y = sin(frameCount*freqMulAng.y) * TWO_PI;
    rot.z = sin(frameCount*freqMulAng.z) * TWO_PI;

   
  }

  void draw() {    
    applyTransforms();
    
    noFill();
    stroke(255);
    strokeWeight(1);

    box(cSize);
    strokeWeight(2);
    for (int j=0; j<4; j++) {
      PVector p = new PVector(bLen, 0); 
      PVector pos = new PVector(cSize/2, 0); 
      float ang = sin(frameCount*aFreq + j%2 * bOffs) * angRange;
      float l = bLen;
      for (int i=0; i<7; i++) {
        stroke(255);
        line(pos.x, pos.y, pos.x + p.x, pos.y + p.y);
        pos.x += p.x;
        pos.y += p.y;
        p = rotateVec(p, ang);
        p.limit(l);
        l *= 0.93;
      }
      rotateY(HALF_PI);
    }
  }

  PVector rotateVec(PVector v, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return new PVector(v.x*c - v.y*s, v.x*s + v.y*c);
  }
    
}

