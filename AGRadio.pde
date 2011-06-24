class AGRadio extends SuperCreature {

  float dir, vit;
  float zPosMul;
  float rOffs;
  float rad;
  float freqMul;
  int num; 
  int blinkFreq;
  int periode;
  float miniDiam;

  ////////////////////////////////////////////////////////////////
  public AGRadio() {
    creatureAuthor = "Andreas Gysin";
    creatureName = "Radio";
    creatureVersion = "1.0";
  
    rOffs = random(100);
    dir = random(TWO_PI);
    vit = random(0.2, 0.8);
    freqMul = random(0.04, 0.08);

    blinkFreq = floor(random(3, 8));
    num = floor(random(3, 12)) * blinkFreq;

    rad = random(10, 80);
    periode = floor(random(3, 16));
    zPosMul = random(-0.0012, 0.0012);
    miniDiam = random(3, 10);
  }

  ////////////////////////////////////////////////////////////////
  void move() {
    pos.x += cos(dir)*vit;
    pos.y += sin(dir)*vit;
    pos.z = sin(frameCount*zPosMul);
    rot.z += 0.01;
    dir += noise(pos.x*0.001, pos.y*0.001)*0.01;
  }

  void draw() {
    translate(pos.x, pos.y, pos.z);
    rotate(rot.z);

    float a = TWO_PI / num;
    float offs = frameCount * freqMul;

    float R = rad + sin(frameCount * 0.03 + rOffs) * rad * 0.2;
    stroke(255); 
    for (int i=0; i<num; i++) {
      float r = sin(float(i) / num * TWO_PI * periode + offs) * R * 0.1;
      float x = cos(a * i) * (R + r);
      float y = sin(a * i) * (R + r);
      line(x/2, y/2, x, y);

      if (((i + frameCount/3)) % blinkFreq == 0) {
        fill(255, 100);
      } 
      else {
        noFill();
      }
     ellipse(x, y, miniDiam, miniDiam);
      fill(255);
      ellipse(x/2, y/2, miniDiam/2, miniDiam/2);
    }
  }
}

