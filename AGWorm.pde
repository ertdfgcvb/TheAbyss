class AGWorm extends SuperCreature {
  ArrayList<Node> nodes;
  ArrayList<Spring> springs;

  PVector dest;
  float nervosismo;
  float diam, spess;

  public AGWorm() {
    creatureAuthor = "Andreas Gysin";
    creatureName = "The Worm";
    creatureVersion = "Beta";

    dest = new PVector(random(width), random(height));

    int num = int(random(10, 20));
    float len = random(5, 10);
    diam = random(5, 20);   
    spess = 1;//random(1, min(diam, 5));
    nervosismo = random(0.01, 0.1);

    nodes = new ArrayList<Node>();
    springs = new ArrayList<Spring>();

    for (int i=0; i<num; i++) {
      Node n = new Node(pos.x + random(-10, 10), pos.y + random(-10, 10), 0.94);
      nodes.add(n);
    }

    for (int i=0; i<num-1; i++) {
      Spring s = new Spring(nodes.get(i), nodes.get(i+1), len, 0.2);
      springs.add(s);
    }
  }

  void move() {
    if (random(1) < nervosismo) {
      dest.x += random(-100, 100);
      dest.y += random(-100, 100);

      dest.x = constrain(dest.x, 50, width-50);
      dest.y = constrain(dest.y, 50, height-50);
    }

    pos.x += (dest.x - pos.x) * 0.02;
    pos.y += (dest.y - pos.y) * 0.02;
  }

  void draw() {
    nodes.get(nodes.size()-1).setPos(pos.x, pos.y);
    for (Spring s : springs) {
      s.step();
    }
    for (Node n : nodes) {
      n.applyForce(new PVector(noise(frameCount*0.01)*0.03, noise(frameCount*0.014)*0.03, 0));
      n.step();
    }

    noFill();
    stroke(255, 100);
    strokeWeight(spess);
    for (Spring s : springs) {
      line(s.a.x, s.a.y, s.b.x, s.b.y);
    }

    stroke(255);
    strokeWeight(1);
    //noStroke();

    int i=0;
    for (Node n : nodes) {
      //fill(255, 100);
      noFill();
      float d = diam + sin(frameCount*0.1 + i*0.9) * diam * 0.3;
      ellipse(n.x, n.y, d, d);
      if ((i + frameCount/5) % 4 == 0) {
        fill(255);
        ellipse(n.x, n.y, d/2, d/2);
      }
      i++;
    }
  }

  class Node extends PVector {

    float damp;
    PVector vel;

    Node(float x, float y, float damp) {
      super(x, y, 0);
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

    void setPos(float x, float y) {
      this.x = x;
      this.y = y;
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

