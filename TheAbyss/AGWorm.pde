/**
 * An example creature with simple spring and node classes.
 * Moves randomly trough the deep waters in search for meaning.
 */
class AGWorm extends SuperCreature {
  ArrayList<Node> nodes;
  ArrayList<Spring> springs;

  PVector dest;
  float nervosismo;
  float radius;
  float rSpeed, rDamp;
  float freq1, freq2;

  public AGWorm() {
    creatureAuthor = "Andreas Gysin";
    creatureName = "El Worm";
    creatureVersion = "Alpha";
    setDate(2011, 6, 10); //Y,M,D

    int num = int(random(7,22));
    float len = random(2, 15);
    float damp = random(0.85, 0.95);
    float k = random(0.15,0.3);
    radius = random(1.5, 2.5);   
    rSpeed = random(50,150);
    rDamp = random(0.005, 0.02);
    nervosismo = random(0.01, 0.3);
    freq1 = random(0.05, 0.2);
    freq2 = random(0.08, 1.1);

    nodes = new ArrayList<Node>();

    springs = new ArrayList<Spring>();
    for (int i=0; i<num; i++) {
      PVector p = PVector.add(pos, new PVector(random(-1,1),random(-1,1),random(-1,1)));
      Node n = new Node(p, damp);
      nodes.add(n);
    }
    
    for (int i=0; i<num-1; i++) {
      Spring s = new Spring(nodes.get(i), nodes.get(i+1), len, k);
      springs.add(s);
    }
    
    dest = new PVector();
  }

  void move() {
    if (random(1) < nervosismo) {
      dest.add(new PVector(random(-rSpeed,rSpeed),random(-rSpeed,rSpeed),random(-rSpeed,rSpeed)));
    }
    pos.x += (dest.x - pos.x) * rDamp;
    pos.y += (dest.y - pos.y) * rDamp;
    pos.z += (dest.z - pos.z) * rDamp;
    nodes.get(0).setPos(pos);
    for (Spring s : springs) s.step();
    for (Node n : nodes) n.step();
  }

  void draw() {
    noFill();
    stroke(255);
    for (Spring s : springs) {
      line(s.a.x, s.a.y, s.a.z, s.b.x, s.b.y, s.b.z);
    }

    int i=0;
    noStroke();
    sphereDetail(3);
    fill(255);  
    float baseFreq = frameCount * freq1;
    for (Node n : nodes) {
      float d = map( sin(baseFreq - i*freq2), -1, 1, radius, radius * 2);
      pushMatrix();
      translate(n.x, n.y, n.z);
      //if ((i + frameCount/5) % 4 == 0) d *= 0.5;
      sphere(d);      
      popMatrix();
      i++;
    }
  }

  class Node extends PVector {

    float damp;
    PVector vel;

    Node(PVector v, float damp) {
      super(v.x, v.y, v.z);
      this.damp = damp;
      vel = new PVector();
    }

    void step() {
      add(vel);
      vel.mult(damp);
    }

    void applyForce(PVector f) {
      vel.add(f);
    }

    void setPos(PVector p) {
      this.x = p.x;
      this.y = p.y;
      this.z = p.z;
      vel = new PVector();
    }
  }
  
  class Spring {
    float len;
    float scaler;
    Node a, b;

    Spring(Node a, Node b, float len, float scaler) {
      this.a = a;
      this.b = b;
      this.len = len;
      this.scaler = scaler;
    }

    void step() {

      PVector v = PVector.sub(b, a);
      float m = (v.mag() - len) / 2 * scaler;
      v.normalize();

      v.mult(m);    
      a.applyForce(v);

      v.mult(-1);    
      b.applyForce(v);
    }
  }
}

