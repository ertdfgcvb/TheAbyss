class AGFred extends SuperCreature {
  float diam;

  //NOISE
  float n1, n2, nm;

  //TRIGO
  float sm1, sm2;
  float rx, ry;

  //INTERP
  PVector dest;
  float destR;

  float len;
  float baseRad;
  int num, numT;
  int blinkFreq;
  float tSpeed, cSpeed;
  float maxAng;
  float nzScaler;


  public AGFred() {
    creatureAuthor = "Andreas Gysin";
    creatureName = "Fred";
    creatureVersion = "Beta";
    diam = random(20, 80);

    n1 = random(100);
    n2 = random(100);   
    nm = random(0.001, 0.005);

    sm1 = random(-0.005, 0.005);
    sm2 = random(-0.005, 0.005);    

    rx = random(width/4, width);
    ry = random(height/4, height);
    nzScaler = random(0.01, 1);
    dest = new PVector(random(width), random(height), 0);
    destR = random(TWO_PI*4);

    len = random(6, 14);
    numT = round(random(4, 6));
    num = round(random(4, 11));
    baseRad = random(7, 20);
    tSpeed = random(0.01, 0.04);
    cSpeed = random(0.04, 0.12);
    blinkFreq = round(random(4, 30));
    maxAng = random(0.4, 1.4);
  }

  void move() {
    /*
    //RANDOM
     pos.x = pos.x + random(-2,2);
     pos.y = pos.y + random(-2,2);
     */

    /*
    //NOISE
     int m = 600;
     pos.x = noise(n1,frameCount*nm) * (width+2*m) - m;
     pos.y = noise(n2,frameCount*nm) * (height+2*m) - m;
     */

    /*
     //TRIGO 
     pos.x = cos(frameCount * sm1) * rx + width/2;
     pos.y = sin(frameCount * sm2) * ry + height/2;
     */

    //INTERP.
    pos.x = pos.x + (dest.x - pos.x) * 0.01;
    pos.y += (dest.y - pos.y) * 0.01;  
    rot.z += (destR - rot.z) * 0.002;

    PVector d = PVector.sub(dest, pos);
    float m = d.mag();
    if (m < 3) {
      float margine = 100;
      dest = new PVector(random(-margine, width+margine), random(-margine, height+margine), 0);
      destR = random(TWO_PI);
    }
  }

  void draw() {
    //fill(255);
    //ellipse(pos.x, pos.y, diam, diam);
    noFill();
    stroke(255);
    rectMode(CENTER);

    translate(pos.x, pos.y, pos.z);
    rotateZ(rot.z);
    float seg = TWO_PI / num;
    float rad = baseRad + sin(frameCount*cSpeed) * (baseRad * 0.2);
    for (int j=0; j<num; j++) {
      float l = len;
      PVector o = new PVector(rad, 0);
      PVector v = new PVector(len, 0);
      float ang = (noise(frameCount*tSpeed, j*nzScaler)-0.5) * maxAng * 2;
      for (int i=0; i<numT; i++) {
        line(o.x, o.y, o.x+v.x, o.y+v.y);
        //rect(o.x, o.y, 2, 2);
        o.add(v);
        v = rotateVec(v, ang);
        l *= 0.9;
        v.limit(l);
      }
      rotate(seg);
    }
    noFill();
    ellipse(0, 0, rad*2, rad*2);
    if (frameCount % blinkFreq == 0) {
      fill(255);
      ellipse(0, 0, baseRad/3, baseRad/3);
    }
  }

  PVector rotateVec(PVector v, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return new PVector(v.x*c - v.y*s, v.x*s + v.y*c);
  }
}

