/**
 * An attempt of a radiolaria-like creature.
 * Uses vertex colors for gradients.
 */
class AGRadio extends SuperCreature {

  PVector pVel, rVel;
  int num, spikes;
  float freq;
  float rad, rFact;

  public AGRadio() {
    creatureAuthor  = "Andreas Gysin";
    creatureName    = "Radio";
    creatureVersion = "Alpha";
    setDate(2012, 7, 27); //Y,M,D

    pVel = new PVector( random(-1, 1), random(-1, 1), random(-1, 1) );
    rVel = new PVector( random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01) );
    num = round(random(20, 100));
    spikes = ceil(random(3, 12));
    freq = random(0.02, 0.06);
    rad = random(30, 60);
    rFact = random(0.2, 0.4);
  }

  void move() {
    pos.add(pVel);  
    rot.add(rVel);  
    applyTransforms();
  }

  void draw() {  
    stroke(255);
    noFill();
    noStroke();
    //hint(DISABLE_DEPTH_TEST); 
    float arc = TWO_PI / num;    
    float f = frameCount * freq;
    float a = arc * spikes;
    beginShape(QUAD_STRIP);
    for (int i=0; i<num+1; i++) { 
      int j = i % num;
      float len = (sin(f + a * j)) * 0.2;
      float c = cos(arc * j); 
      float s = sin(arc * j);
      float x = c * (rad + len * rad);
      float y = s * (rad + len * rad);
      float z = len * rad;
      fill(255  ); 
      vertex(x*rFact, y*rFact, z);
      fill(i % 2 * 255, 0); 
      vertex(x, y, 0);
    }
    endShape();
    //hint(ENABLE_DEPTH_TEST);
  }
}

