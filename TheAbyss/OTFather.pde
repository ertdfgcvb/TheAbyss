class OTFather extends SuperCreature {
  int count;
  int numSegmenti;
  int numTentacoli;
  int numPinne;
  float distPinne;
  float l;

  //TRIGO
  float sm1, sm2;
  float rx, ry;
  PVector pVel, rVel, noiseVel;

  public OTFather() {
    creatureName = "Father";
    creatureAuthor = "Oliviero Tavaglione";
    creatureVersion = "Beta";
    setDate(2011, 5, 7); //Y,M,D


    numSegmenti = floor(random(10, 20));
    numTentacoli = 1;
    numPinne = floor(random(2, 6));
    distPinne = random(0.2, 0.5);
    l = random(20, 40);

    sm1 = random(-0.005, 0.005);
    sm2 = random(-0.005, 0.005);    


    pVel = PVector.random3D();
    rVel = PVector.random3D();
    rVel.mult(random(0.01, 0.03));
    noiseVel =PVector.random3D();
    noiseVel.mult(random(0.005, 0.03));
    float s = random(0.5, 1);
    sca.set(s,s,s);
  }

  void move() {
    count++;
    pos.add(pVel);  
    rot.add(rVel);  
    applyTransforms();
  }


  void draw() {
    sphereDetail(8);

    //TESTA
    fill(255,100);
    stroke(255);
    sphere(l);

    //ANTENNE
    stroke(255);

    //float ly = sin(frameCount * 0.01) * 30;
    //float lz = -sin(frameCount * 0.01) * 30;
    float ly = random(l/2, sin(count * 0.01) * l);
    float lz = random(l, l + (l/1.5));


    line(0, 0, 0, -l*2, 10, 30);
    line(0, 0, 0, -l*2, 10, -30);

    //PINNE  
    rotateY(-(numPinne-1) * distPinne / 2);
    //rotateY(-(numPinne-1) * distPinne / (distPinne - TWO_PI));
    for (int k=0; k<numPinne; k++) {

      float s = (cos(TWO_PI / (numPinne-1) * k));
      s = map(s, 1, -1, 0.9, 1);
      // println(k + "   " + s);
      pushMatrix();
      scale(s);


      for (int j=0; j<numTentacoli; j++) {
        pushMatrix();
        float a = (noise(count*noiseVel.x + j+k+1)-0.4)*0.782; 
        float b = (noise(count*noiseVel.y + j+k+1)-0.5)*0.582; 
        float c = (noise(count*noiseVel.z + j+k+1)-0.6)*0.682;

        for (int i=0; i<numSegmenti; i++) {
          rotateZ(a);
          rotateY(b);
          rotateX(c);
          translate(l*0.9, 0, 0);
          scale(0.85, 0.85, 0.85);
          box(l, l/2, l); 
          //ellipse(l/2, l, l, l);
        }


        popMatrix();


        //rotateY(TWO_PI/numTentacoli);
      }
      popMatrix();
      rotateY(distPinne);
    }
  }
}

