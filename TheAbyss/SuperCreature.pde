/**
 * The SuperCreature class
 * Every creature will extend this class.
 */
abstract class SuperCreature {
  protected PVector pos, rot, sca;
  private PVector projectedPos;
  private float energy, power;
  String creatureName, creatureAuthor, creatureVersion;
  CreatureDate creatureDate;
  CreatureManager cm;

  public SuperCreature() {
    creatureName = "Unknown";
    creatureAuthor = "Anonymous";
    creatureVersion = "Alpha";
    creatureDate = new CreatureDate(); 

    energy = 100.0;
    power = 0.02;
    pos = new PVector();
    projectedPos = new PVector();
    rot = new PVector();
    sca = new PVector(1, 1, 1);
  }

  void setManagerReference(CreatureManager cm) {
    this.cm = cm;
  }

  abstract void move();
  abstract void draw();

  //applies the default transforms... can be used as a shortcut
  void applyTransforms() {
    translate(pos.x, pos.y, pos.z);
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);
    scale(sca.x, sca.y, sca.z);
  }

  private void preDraw() {
    energy = max(0, energy - power); //creatures with energy == 0 will be removed
    pushStyle();
    strokeWeight(1); //apparently a pushStyle bug?
    pushMatrix();     
    // transforms are handled by the creature 
    // this allows greater flexibility for example for particle based creatures 
    // which don't use matrix transforms
    // we don't pre-translate, rotate and scale:
    // translate(pos.x, pos.y, pos.z);
    // rotateX(rot.x);
    // rotateY(rot.y);
    // rotateZ(rot.z);
    // scale(sca.x, sca.y, sca.z);
  };  


  private void postDraw() {
    popMatrix(); 
    popStyle();
    projectedPos.x = screenX(pos.x, pos.y, pos.z);
    projectedPos.y = screenY(pos.x, pos.y, pos.z);
  };

  PVector getPos() {
    return pos.get();
  }

  void setPos(PVector pos) {
    this.pos = pos.get();
  }

  void creatureHasBeenAdded(SuperCreature c) {
  }

  SuperCreature getNearest() {
    return getNearest("");
  }

  SuperCreature getNearest(String creatureName) {
    float d = MAX_FLOAT;
    SuperCreature nearest = null;
    for (SuperCreature c : cm.getCreatures()) {
      if (c != this && (c.creatureName != creatureName)) {
        PVector p = c.getPos();
        PVector m = PVector.sub(pos, p);
        float s = m.x * m.x + m.y * m.y + m.z * m.z;//m.mag();
        if (s < d) {
          d = s; 
          nearest = c;
        }
      }
    }
    return nearest;
  }

  void showAxis() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);   
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);    
    float l = 100;
    strokeWeight(1);
    stroke(255, 0, 0);
    line(0, 0, 0, l, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, l, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, l);
    popMatrix();
  }

  void showInfo() {
    if (cm.getCamera().eyeDist(pos) < 1200) {
      pushStyle();
      fill(255);
      stroke(255);
      float x = projectedPos.x;
      float y = projectedPos.y;
      ellipse(x, y, 6, 6);
      line(x, y, x+70, y-70);
      String s = creatureName + "\n" + creatureAuthor + "\n" + creatureVersion + "\n";
      s += creatureDate + "\n";
      s += "energy: " + nf(energy, 0, 1);
      text(s, x+70, y-70);
      popStyle();
    }
  }
  /*
  //not working well, yet... quats needed.
  void lookAt(PVector p) {
   lookAt(p, 1.0);
   }
   
   void lookAt(PVector target, float damp) {
   
   PVector p = PVector.sub(target, pos);
   float dy = p.mag();
   float dz = sqrt(p.x*p.x + p.y*p.y);
   float ry = acos(p.z/dy);
   float rz;
   if (p.y >= 0) {
   rz = acos(p.x/dz);
   } 
   else {
   rz = TWO_PI - acos(p.x/dz);
   }
   rot.x += (0  - rot.x) * damp;
   rot.y += (ry - rot.y) * damp;
   rot.z += (rz - rot.z) * damp;    
   }
   */
    
  float getEnergy() {
    return energy;
  }

  void kill() {
    energy = 0.0;
  }

  void setDate(int y, int m, int d) {
    creatureDate.set(y, m, d);
  }
  
  //just a trivial date object
  class CreatureDate {
    int y, d, m; 

    CreatureDate() {
      this.y = 2000;
      this.d = 1;
      this.m = 1;
    }

    CreatureDate(int y, int m, int d) {
      set(y, m, d);
    }

    public void set(int y, int m, int d) {
      this.y = y;
      this.d = d;
      this.m = m;
    }

    public String toString() {
      return y + "." + d + "." + m;
    }
  }
}

