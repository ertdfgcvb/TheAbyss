class AGJelly extends SuperCreature {

  float d1, d2, hauteur;
  float freqMul;
  int num, freqNum;
  PVector freqMulPos, freqMulAng;

  public AGJelly() {
    creatureAuthor = "Andreas Gysin";
    creatureName = "Jelly";
    creatureVersion = "Alpha";

    d1 = random(0, 20);
    d2 = random(25, 65); 
    hauteur = random(-80, 80);
    freqMul = random(0.005, 0.1);

    freqMulPos = new PVector();
    freqMulPos.x = random(-0.0012, 0.0012); 
    freqMulPos.y = random(-0.0012, 0.0012); 
    freqMulPos.z = random(-0.0012, 0.0012);

    freqMulAng = new PVector();
    freqMulAng.x = random(-0.0012, 0.0012); 
    freqMulAng.y = random(-0.0012, 0.0012); 
    freqMulAng.z = random(-0.0012, 0.0012);

    freqNum = floor(random(3,8));
    num = floor(random(3,8)) * freqNum;
  }

  void move() {
    pos.x += sin(frameCount*freqMulPos.x);
    pos.y += sin(frameCount*freqMulPos.y);
    pos.z += sin(frameCount*freqMulPos.y);

    rot.x = sin(frameCount*freqMulAng.x) * TWO_PI;
    rot.y = sin(frameCount*freqMulAng.y) * TWO_PI;
    rot.z = sin(frameCount*freqMulAng.z) * TWO_PI;
  }

  void draw() {
    bezierDetail(9);
    translate(pos.x, pos.y, pos.z);
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);    

    noFill();

    float b = TWO_PI / num;

    float x1=d1;
    float y1=0;
    float x2=d2;
    float y2=hauteur;
    float cx1=x1+(x2-x1)/3;
    float cy1=y1+(y2-y1)/3;
    float cx2=x1+(x2-x1)/3*2;
    float cy2=y1+(y2-y1)/3*2;

    float a = frameCount*freqMul;
    float r = dist(x1,y1,x2,y2)/3;

    cx1+=cos(a)*r;
    cy1+=sin(a)*r;
    cx2+=cos(a*0.95)*r;
    cy2+=sin(a*0.95)*r;

    pushMatrix();
    rotateX(HALF_PI);
    stroke(255);
    strokeWeight(3);
    ellipse(0,0,x1*2,x1*2);
    popMatrix();
    for (int i=0; i<num; i++) {
      rotateY(b);
      if (i%freqNum==0) {
        strokeWeight(3);
      } 
      else {
        strokeWeight(1);
      }
      bezier (x1, y1, cx1, cy1, cx2, cy2, x2, y2);
      point(x2+10,y2);
    }
  }
}

