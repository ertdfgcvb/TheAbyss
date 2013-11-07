class LPHubert extends SuperCreature {

  PVector freqMulPos, freqMulAng;
  int num;
  int count;
  
  float cSize;
  float bLen;
  float aFreq;
  float bOffs;
  float angRange;
  float angT, scaR;

  int numberT, numberSeg, elSize, val2div;

  boolean isAngry = false;
  ArrayList<Missile> missiles = new ArrayList<Missile>();

  public LPHubert() {
    creatureAuthor ="Laura Perrenoud";
    creatureName ="Hubert";
    creatureVersion ="1.0";
    setDate(2012, 4, 26);

    //////////////Mouvement alétoire
    freqMulPos = new PVector();
    freqMulPos.x = random(-0.002, 0.002); 
    freqMulPos.y = random(-0.002, 0.002); 
    freqMulPos.z = random(-0.002, 0.002);

    freqMulAng = new PVector();
    freqMulAng.x = random(-0.005, 0.005); 
    freqMulAng.y = random(-0.005, 0.005); 
    freqMulAng.z = random(-0.005, 0.005);
    /////////////////

    ///////////////Créature random
    num = 10;
    cSize = random(6, 30);
    bLen = random(5, 15);
    aFreq = random(0.01, 0.02);
    bOffs = random(5);
    angRange = random(0.3, 0.6);
    numberT = int(random(3, 20));
    numberSeg = int(random(3, 7));
    elSize = 5;
    val2div = int(random(1, 3));
    scaR = (random(0.3, 1.52));
    sca.x = scaR;
    sca.y = scaR;
    sca.z = scaR;
    ////////////////
  }

  void move() {
    count++;
    ////////////////
    pos.x += sin(count*freqMulPos.x);
    pos.y += sin(count*freqMulPos.y);
    pos.z += sin(count*freqMulPos.z);

    rot.x = sin(count*freqMulAng.x) * TWO_PI;
    rot.y = sin(count*freqMulAng.y) * TWO_PI;
    rot.z = sin(count*freqMulAng.z) * TWO_PI;

    //    SuperCreature x = getNearest("Hubert");
    //    if (x != null) {
    //      float dis = dist(x.pos.x, x.pos.y, x.pos.z, pos.x, pos.y, pos.z);
    //      if (dis < 320 && !isAngry) {
    //        isAngry = true;
    //
    //        for (int i=0; i<random(3, 6); i++) {
    //          missiles.add(new Missile(pos, x));
    //        }
    //      } 
    //      else {
    //        isAngry = false;
    //      }
    //    }
    applyTransforms();
    //    launchMissile();
  }

  void draw(color colorCreature) {

    strokeWeight(1);
    noFill();
    stroke(colorCreature, 150);
    float val2 = sin(count*aFreq*3)*2;
    
    float a1 = sin(count*aFreq + bOffs) * angRange;
    float a2 = sin(count*aFreq) * angRange;

    for (int j=0; j<numberT; j++) {

      PVector p = new PVector(bLen, 0); 
      PVector pos = new PVector(cSize/6, 0); 
      float ang = (j % 2 == 0) ? a1 : a2;
      float l = bLen;

      for (int i=0; i<numberSeg; i++) {
        if (i<numberSeg-2) {
          pushMatrix();
          translate(pos.x + p.x, pos.y + p.y, 0);
          box(3+val2);
          popMatrix();
        }

        line(pos.x, pos.y, pos.x + p.x, pos.y + p.y);
        pos.x += p.x;
        pos.y += p.y;
        p = rotateVec(p, ang+(val2 * 0.1));
        p.limit(l);
        l *= 0.99;
        //l *= 0.93;
      }
      rotateY(PI*2/numberT);
    }
  }

  PVector rotateVec(PVector v, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return new PVector(v.x*c - v.y*s, v.x*s + v.y*c);
  }

  void launchMissile (color colorCreature) {
    for (int i=missiles.size()-1; i>=0; i--) {
      Missile d = (Missile)missiles.get(i);
      d.draw(colorCreature);
      if (d.dis <= 23) {
        if (d.target.sca.x <= 0) {
          d.target.kill();
        } 
        else {
          d.target.sca.sub(new PVector(.01, .01, .01));
        } 
        missiles.remove(i);
      }
    }
  }

  class Missile {
    //
    SuperCreature target;
    PVector pos, tar, vec;
    float a1, a2;
    float dis;
    float speed;
    //
    Missile(PVector _p, SuperCreature _target) {
      target = _target;
      pos = _p.get();
      tar = _target.pos;
      vec = PVector.sub(tar, pos);
      vec.normalize();

      speed = random(2, 7);

      vec.mult(speed);
    }
    //
    void draw(color colorCreature) {

      vec = PVector.sub(tar, pos);
      vec.normalize();
      vec.mult(speed);

      dis = dist(tar.x, tar.y, tar.z, pos.x, pos.y, pos.z);

      pos.add(vec);

      pushStyle();
      pushMatrix();
      translate(pos.x, pos.y, pos.z);
      stroke(colorCreature, 0, 0);
      point(0, 0, 0);
      popMatrix();
      popStyle();
    }
  }
}
