class PXPSonar extends SuperCreature {

  int time;
  int count;
  int bold = 2;
  int freq = 300;
  float fadeSpeed = 5;
  PVector freqMulRot, freqMulSca, freqMulPos;

  public PXPSonar() {
    creatureAuthor  = "Pierre-Xavier Puissant";
    creatureName    = "Sonar";
    creatureVersion = "1.0";
    setDate(2012, 4, 25); //Y,M,D

    freqMulRot = new PVector();
    freqMulRot.x = random(-0.0005, 0.0005);
    freqMulRot.y = random(-0.001, 0.001);
    freqMulRot.z = random(-0.0015, 0.0015);

    freqMulPos = new PVector();
    freqMulPos.x = random(-0.002, 0.002); 
    freqMulPos.y = random(-0.002, 0.002); 
    freqMulPos.z = random(-0.002, 0.002);

    /*freqMulSca = new PVector();
     freqMulSca.x = random(-0.005, 0.005);
     freqMulSca.y = random(-0.005, 0.005);
     freqMulSca.z = random(-0.005, 0.005);*/
  }

  void move() {
    rot.x = sin(frameCount*freqMulRot.x) * TWO_PI;
    rot.y = sin(frameCount*freqMulRot.y) * TWO_PI;
    rot.z = sin(frameCount*freqMulRot.z) * TWO_PI;

    pos.x += sin(frameCount*freqMulPos.x);
    pos.y += sin(frameCount*freqMulPos.y);
    pos.z += cos(frameCount*freqMulPos.z);

    applyTransforms();
  }

  void draw() {
    time++;
    count++;
    float changeWH;
    float changeAL;
    float changeSca = map(sin(count*0.15), -1,1, 1, 1.5);
    
    noFill();
    for (int i = 0; i < bold; i++) { 
      changeAL = (freq-time*fadeSpeed)*(sin((PI/bold)*i));
      stroke(255, 255, 255, changeAL*2);
      changeWH = exp(sqrt(time*0.75))+i;
      ellipse (0, 0, changeWH, changeWH);
    }
    if (time > freq) {
      time = 0;
    }

    rotateX(count*0.011);
    rotateX(count*0.012);
    rotateZ(count*0.013);

    stroke (255, 80);    
    sphereDetail(6);
    sphere(30);    
    scale(changeSca, changeSca, changeSca);
    stroke (255);
    sphereDetail(1);
    sphere(10);
  }
}

