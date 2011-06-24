/**
 * SuperCreature
 * 
 * the two main methods are:
 * move() here the transformations should take place. 
 * use the 'pos', 'rot' and 'sca' vectors for the creature transforms.
 * pos is also used for mouse displacement and info display.
 * it's important that pos reflects the actual position of the creature (head?) so all creatures are aware of each creature's position. 
 * 
 * draw() for the graphical output. 
 * in case translate the matrix to pos or just use pos to draw your creature in the desired position.
 * a common rule is to use only white stroke and white fill (with alpha). 
 * of course this rule can be broken!
 */


abstract class SuperCreature {
  protected PVector pos, rot, sca;
  String creatureName, creatureAuthor, creatureVersion;
  CreatureManager cm;

  public SuperCreature() {
    creatureName = "Unknown";
    creatureAuthor = "Anonymous";
    creatureVersion = "Alpha";
    pos = new PVector(width/2, height/2);
    rot = new PVector();
    sca = new PVector(1, 1, 1);
  }
  
  //a quick and ugly hack!
  void setManagerReference(CreatureManager cm) {
    this.cm = cm;
  }

  abstract void move();
  abstract void draw();
  
  private void preDraw() {
    pushStyle();
    pushMatrix();
  };  
  
  
  private void postDraw() {
    popStyle();
    popMatrix();
  };

  PVector getPos() {
    return pos.get();
  }

  void setPos(PVector p) {
    pos = p.get();
  }

  void creatureHasBeenAdded(SuperCreature c) {
  }

  SuperCreature getNearest() {
    ArrayList<SuperCreature> others = cm.getCreatures();
    float d = MAX_FLOAT;
    SuperCreature nearest = null;
    for (SuperCreature c : others) {
      if (c != this) {
        PVector p = c.getPos();
        PVector m = PVector.sub(pos, p);
        float s = m.mag();
        if (s < d) {
          d = s; 
          nearest = c;
        }
      }
    }
    return nearest;
  }

  void showInfo() {
    pushStyle();
    fill(255);
    stroke(255);
    float x = screenX(pos.x, pos.y, pos.z);
    float y = screenY(pos.x, pos.y, pos.z);  
    ellipse(x, y, 6, 6);
    line(x, y, x+70, y-70);
    String s = creatureName + "\n" + creatureAuthor + "\n" + creatureVersion;
    text(s, x+70, y-70);
    popStyle();
  }

  void kill() {
    cm.killCreature(this);
  }
}

