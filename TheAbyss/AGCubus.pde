/**
 * A creature with four tentacles.
 * Floats it's life away in the Abyss.
 */
class AGCubus extends SuperCreature {
  PVector fPos, fAng;
  float cSize;
  int segments;
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
    fPos = new PVector(random(-0.002, 0.002), random(-0.002, 0.002), random(-0.002, 0.002));
    fAng = new PVector(random(-0.005, 0.005), random(-0.005, 0.005), random(-0.005, 0.005));
    
    segments = int(random(5,9));
    bLen = random(4, 10);
    aFreq = random(0.01, 0.1);
    bOffs = random(5);
    angRange = random(0.3, 0.6);
  }

  void move() {    
    pos.x += sin(frameCount*fPos.x);
    pos.y += sin(frameCount*fPos.y);
    pos.z += cos(frameCount*fPos.y);

    rot.x = sin(frameCount*fAng.x) * TWO_PI;
    rot.y = sin(frameCount*fAng.y) * TWO_PI;
    rot.z = sin(frameCount*fAng.z) * TWO_PI; 
  }

  void draw() {    
    applyTransforms(); //shortcut   
    noFill();
    stroke(255);

    // the body
    strokeWeight(1);
    box(cSize); 
    
    //the four tentacles
    strokeWeight(2);
    for (int j=0; j<4; j++) {
      PVector p = new PVector(bLen, 0); 
      PVector pos = new PVector(cSize/2, 0); 
      float ang = sin(frameCount*aFreq + j%2 * bOffs) * angRange;
      float l = bLen;
      beginShape();
      for (int i=0; i<segments+1; i++) {
        vertex(pos.x, pos.y);
        pos.x += p.x;
        pos.y += p.y;
        p = rotateVec(p, ang);
        p.limit(l);
        l *= 0.93; //scale a bit, this factor could also be randomized.
      }
      endShape();
      rotateY(HALF_PI);
    }
  }

  PVector rotateVec(PVector v, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return new PVector(v.x*c - v.y*s, v.x*s + v.y*c);
  }    
}

