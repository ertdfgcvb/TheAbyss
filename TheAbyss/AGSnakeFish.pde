/**
 * A creature wich uses matrix transforms for positioning.
 * This allows a plane-like movement.
 */
class AGSnakeFish extends SuperCreature {

  PMatrix3D mat;
  PVector dim;  
  int queueLen;
  ArrayList <PVector> queue;
  float maxSpeed;
  float sF, rXF, rYF, rXA, rYA;
  float oS,oX,oY;

  public AGSnakeFish() {
    creatureAuthor  = "Andreas Gysin";
    creatureName    = "SnakeFish";
    creatureVersion = "Beta";
    setDate(2012, 4, 26); //Y,M,D

    dim = new PVector(random(20, 60), random(10, 20));
    mat = new PMatrix3D();
    queueLen = int(random(50, 200));
    sF = random(0.005, 0.01);
    rXF    = random(0.005, 0.01);
    rYF    = random(0.05, 0.15);
    rXA     = random(0.05, 0.15);
    rYA     = random(0.05, 0.15);

    oS   = random(TWO_PI);
    oX   = random(TWO_PI);
    oY   = random(TWO_PI);    
    
    queue    = new ArrayList<PVector>();
    maxSpeed = random(8,15);
  }

  void move() {
    float speed = map(sin(frameCount * sF + oS), -1, 1, 2, maxSpeed);   
    mat.translate(0, 0, speed);
    mat.rotateX(map(sin(frameCount * rXF + oX), -1, 1, -rXA, rXA));   
    mat.rotateY(map(sin(frameCount * rYF + oY), -1, 1, -rYA, rYA));
    mat.mult(new PVector(), pos); //we are nice and manually update the pos vector...
  }

  void setPos(PVector p) {
    float[] a = mat.get(null);
    a[3] = p.x;
    a[7] = p.y;
    a[11] = p.z;
    mat.set(a);
  }

  void draw() {    
    dim.mult(constrain(getEnergy() * 0.95,0,1));

    PVector p1 = new PVector(); 
    PVector p2 = new PVector();
    mat.mult(new PVector(-dim.x/2, 0, 0), p1);
    mat.mult(new PVector( dim.x/2, 0, 0), p2);
    queue.add(p1);
    queue.add(p2);

    noFill();
    if (queue.size() > queueLen) {
      queue.remove(0);
      queue.remove(0);
    }
    
    stroke(255);
    
    beginShape();  
    for (int i=0; i<queue.size(); i+=2) {
      PVector v1 = queue.get(i);
      //stroke(255, min(i, 255));
      vertex(v1.x, v1.y, v1.z);
    }
    endShape();

    beginShape();  
    for (int i=1; i<queue.size(); i+=2) {
      PVector v = queue.get(i);
      //stroke(255, min(i, 255));
      vertex(v.x, v.y, v.z);
    }
    endShape();


    applyMatrix(mat);
    rotateX(HALF_PI);  
    stroke(255);
    rect(-dim.x/2, 0, dim.x, dim.y);
  }
}

