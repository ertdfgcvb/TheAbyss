class MCManta extends SuperCreature {

  int sz, lgth, nb;
  float ang;
  float vel, freqY, ampY;
  //PVector colorF;
  PVector wingsAmp;
  int count;

  public MCManta() {
    creatureAuthor  = "Maxime Castelli";
    creatureName    = "Manta";
    creatureVersion = "Beta";
    setDate(2012, 4, 22); //Y,M,D

    freqY = random(0.01, 0.03);
    ampY = random(30, 90);
    //    colorF = new PVector();
    //    colorF.x = random(0.001, 0.004); 
    //    colorF.y = random(0.001, 0.004); 
    //    colorF.z = random(0.001, 0.004);

    ang = random(TWO_PI);
    vel = random(1, 2);

    wingsAmp = new PVector();
    wingsAmp.x = random(0.01, 0.15);
    wingsAmp.y = random(0.01, 0.15);
  }

  void move() {
    count++;
    pos.x += cos(ang) * vel;
    pos.y = cos(count*freqY) * ampY;
    pos.z += sin(ang) * vel;
    rot.y = -ang;
    applyTransforms();
  }

  void draw() {

    sz = 25;
    lgth = 300;
    nb = lgth /sz ;

    noFill();
    stroke(255);
    rotateY(PI);

    //TETE
    sphereDetail(2);
    for (int i=0; i<2; i++) {
      pushMatrix();
      translate(40 +i*15, 0 +(sin(i+count*0.1)));
      scale(2, i*0.8);
      sphere(15);
      popMatrix();
    }

    //AILE 1
    pushMatrix();
    rotateX(0.6*sin(count * wingsAmp.x) + radians(90));
    beginShape(TRIANGLE_STRIP);
    for (int l1=0; l1<10; l1++) {
      vertex(pow(l1, 2), l1*10, sin(count*wingsAmp.y)*5);
      vertex(75, 25, cos(count*wingsAmp.x)*10);
    }
    vertex(120, 0);
    endShape(CLOSE);  
    popMatrix();

    //AILE 2
    pushMatrix();
    rotateX(-0.6*sin(count * wingsAmp.x) - radians(90));
    beginShape(TRIANGLE_STRIP);
    vertex(0, 0);
    for (int l2=0; l2<10; l2++) {
      vertex(pow(l2, 2), l2*10, sin(count*wingsAmp.y)*5);
      vertex(75, 25, -cos(count*wingsAmp.x)*10);
    }
    vertex(120, 0);
    endShape(CLOSE);
    popMatrix();

    //QUEUE
    translate(80, 0);
    beginShape(TRIANGLE_STRIP); 
    for (int j=0; j<15;j++) {
      vertex(j*10, sin(j-(count* wingsAmp.x))*(j), cos(j-(count* wingsAmp.y))*(j));
    }
    endShape();
  }
}

