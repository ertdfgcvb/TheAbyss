class MFCreatureZero extends SuperCreature {


  int count;
  PVector dest;
  float nervosismo;
  float diam;
  int q = int(random(2, 5));
  int p = q + int(random(1, 4));
  float rFreq = random(0.02, 0.06);

  public MFCreatureZero() {
    creatureName = "Creature Zero";
    creatureAuthor = "Martin Fröhlich";
    creatureVersion = "1.0";
    setDate(2011, 5, 7); //Y,M,D

    dest = new PVector();

    int num = int(random(5, 30));
    float len = random(2, 10);
    diam = random(4, 20);   
    nervosismo = random(0.01, 0.4);


    /**
     for (int i=0; i<num; i++) {
     Node n = new Node(pos.x + random(-10, 10), pos.y + random(-10, 10), 0.9);
     nodes.add(n);
     }
     
     for (int i=0; i<num-1; i++) {
     Spring s = new Spring(nodes.get(i), nodes.get(i+1), len, 0.1);
     springs.add(s);
     }
     **/
  }

  void move() {
    count++;
    if (random(1) < nervosismo) {
      PVector rnd = PVector.random3D();
      rnd.mult(30);
      dest.add(rnd);
    }

    pos.x += (dest.x - pos.x) * 0.02;
    pos.y += (dest.y - pos.y) * 0.02;
    pos.z += (dest.z - pos.z) * 0.02;
  }

  void draw() {
    hint(DISABLE_DEPTH_TEST); 
    stroke(255, 95);
    strokeWeight(2);
    noFill();
    translate(pos.x, pos.y, pos.z);
    float rad =  sin(count*rFreq);
    rotateY(rad);
    rotateX(rad);
    rotateZ(rad);

    int r = (int)diam;
    int numberOfSteps = 150;
    float angleSize = p * PI / numberOfSteps;
    beginShape();
    for (int i = 1; i < numberOfSteps; i++) {
      float pc0 = cos(p * (i - 1) * angleSize);
      float pc1 = cos(p * (i) * angleSize); 

      vertex(
      r*(3+pc0) * cos(q * (i - 1) * angleSize), 
      r*(3+pc0) * sin(q * (i - 1) * angleSize), 
      r*sin(p * (i - 1) * angleSize)
      );
      vertex(
      r*  (3+pc1) * cos(q * (i) * angleSize), 
      r*  (3+pc1) * sin(q * (i) * angleSize), 
      r*  sin(p * (i) * angleSize)
      );      
    }
    endShape(CLOSE);
    hint(ENABLE_DEPTH_TEST);
  }
}

