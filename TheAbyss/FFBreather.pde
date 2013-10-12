class FFBreather extends SuperCreature {

  PVector oldPosition;
  PVector acc = new PVector(0,0);
  float xoff = 0.1, yoff = 10.45;
  float xadd = 0.001, yadd = 0.005;
  float xNoise = 0, yNoise = 0;
  PVector inside = new PVector(0,0);
  PVector center = new PVector(0,0);
  float sizeIt = 0, addSizeIt = 00.01;
  float sizeItCos, breath, breathoff, breathadd;
  PVector one,two,three, len, newCenter;
  ArrayList<PVector >points  = new ArrayList <PVector>();
  float start = 0.0;
  
  PVector rVel, pVel;

  int creatureSize, creatureWidth, realCreatureSize;
  float moveAroundCircle;

  public FFBreather() {
    creatureName = "The Breather";
    creatureAuthor = "Fabian Frei";
    creatureVersion = "1";
    setDate(2011, 5, 7); //Y,M,D
    
    randomStart();

    // math the shit out of it
    for(int i = 0;i < realCreatureSize;i++)
    {
      points.add(new PVector(cos(start)*creatureWidth,sin(start)*creatureWidth) );
      start += moveAroundCircle;
    }
    //println(points);
  }

  void randomStart() 
  {
    creatureSize = (int)random(3,11);
    if(creatureSize%2 != 0)
    {
      creatureSize++;
    }
    //println("creatureSize = " + creatureSize);
    realCreatureSize = 3*creatureSize;
    //println("realCreatureSize = " + realCreatureSize);
    creatureWidth = (int)random(10,100);
    moveAroundCircle = TWO_PI/realCreatureSize;

    pos = new PVector(random(0,width),random(0,height));
    oldPosition = pos;

    sizeIt = 0;
    addSizeIt = random(0.001,0.1);
    breathoff = random(0.001,0.01);
    breathadd = random(0.0001,0.001);
    xoff = random(0.001,0.1);
    yoff = random(10,100);
    xadd = random(0.00001,0.01);
    yadd = random(0.00001, 0.01);

     pVel = PVector.random3D();
    rVel = PVector.random3D();
    rVel.mult(random(0.01, 0.03));
    float s = random(0.5, 1);
    sca.set(s,s,s);
  }


  void move() {
    breath = noise(breathoff);
    breathoff += breathadd;

    sizeItCos = map(cos(sizeIt),-1,1,breath,1);
    sizeIt = sizeIt + addSizeIt;

    pos.add(pVel);  
    rot.add(rVel);  
    applyTransforms();
  }


  void draw() {
    stroke(255,255,255,95);
    noFill();

    for(int i = 0; i < points.size()-1;i+=2)
    {
      one = points.get(i);
      two =  points.get(i+1);

      if( i+2 < points.size() )
      {
        three = points.get(i+2);
      } 
      else {
        three = points.get(0);
      }

      len = PVector.sub(center,two);
      newCenter = PVector.add(PVector.mult(len,sizeItCos),two);

      beginShape(); 
      vertex(one.x,one.y,0);
      vertex(newCenter.x,newCenter.y,15+breath*75);
      vertex(three.x,three.y,0);
      endShape(CLOSE);
    }
  }
}

