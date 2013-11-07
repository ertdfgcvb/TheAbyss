/**
 * The core class.
 * Takes care of instantiating creatures and makes them live and die.
 */

import java.util.Iterator;
import java.lang.reflect.*; 

class CreatureManager {
  private ArrayList<SuperCreature>creatures;
  private ArrayList<Class>creatureClasses;

  int currentCameraCreature =-1;
  PVector releasePoint;

  SuperCreature previewCreature;  
  PApplet parent;
  String infoText;

  int currentCreature = -1;
  boolean showCreatureInfo = false;
  boolean showCreatureAxis = false;
  boolean showAbyssOrigin  = true;
  boolean showManagerInfo = true;
  //boolean highTextQuality = false;

  CreatureManager(PApplet parent) {
    PFont fnt = loadFont("Monaco-12.vlw");
    textFont(fnt);
    textLeading(17);
    this.parent = parent;
    releasePoint = PVector.random3D();
    releasePoint.mult(100);
    creatures = new ArrayList<SuperCreature>();

    creatureClasses = scanClasses(parent, "SuperCreature");
    if (creatureClasses.size() > 0) selectNextCreature();
  }

  private ArrayList<Class> scanClasses(PApplet parent, String superClassName) {
    ArrayList<Class> classes = new ArrayList<Class>();  
    infoText = "";
    Class[] c = parent.getClass().getDeclaredClasses();
    for (int i=0; i<c.length; i++) {
      if (c[i].getSuperclass() != null && (c[i].getSuperclass().getSimpleName().equals(superClassName) )) {
        classes.add(c[i]);
        int n = classes.size()-1;
        String numb = str(n);
        if (n < 10) numb = " " + n;
        infoText += numb + "         " + c[i].getSimpleName() + "\n";
      }
    }
    println("------------------------------------------------------");
    println("Classes which extend " + superClassName + ":");  
    println(infoText);
    return classes;
  }

  public void showCreatureInfo() {
    for (SuperCreature c : creatures) {
      c.drawInfo(c.getPos());
    }
  }

  public void showInfo(PGraphics g) {
    fill(255);
    noStroke();
    String s = "";
    s += "           the abyss v.2.1\n";
    s += "           2010-2013\n";
    s += "------------------------------------\n";
    s += "fps        " + round(frameRate) + "\n";
    s += "num        " + creatures.size() + "\n";
    s += "------------------------------------\n";
    s += infoText;
    s += "------------------------------------\n";
    s += "left/right next/prev creature\n";   
    s += "space      add current creature\n";   
    s += "up/down    next/prev creature cam\n";   
    s += "c          auto rotate cam\n";
    s += "           \n";
    s += "r          add random creature\n";
    s += "h          toggle help\n";
    s += "i          toggle creature info\n";
    s += "a          toggle creature axes\n";
    s += "o          toggle abyss origin\n";
    s += "b          toggle background\n";
    s += "x          kill all!\n";
    text(s, 10, 20);
  }

  ArrayList<SuperCreature> getCreatures() {
    return creatures;
  }

  public SuperCreature addCreature( int i) {
    if (i < 0 || i >= creatureClasses.size()) return null;

    SuperCreature f = null;
    try {
      Class c = creatureClasses.get(i);
      Constructor[] constructors = c.getConstructors();
      f = (SuperCreature) constructors[0].newInstance(parent);
    } 

    catch (InvocationTargetException e) {
      System.out.println(e);
    } 
    catch (InstantiationException e) {
      System.out.println(e);
    } 
    catch (IllegalAccessException e) {
      System.out.println(e);
    } 

    if (f != null) {
      releasePoint = PVector.random3D();
      releasePoint.mult(100);
      addCreature(f);
    }
    return f;
  }

  private void addCreature(SuperCreature c) {
    c.setManagerReference(this);
    creatures.add(c);
    tellAllThatCreatureHasBeenAdded(c);
  }

  private void tellAllThatCreatureHasBeenAdded(SuperCreature cAdded) {
    for (SuperCreature c : creatures) {
      c.creatureHasBeenAdded(cAdded);
    }
  }

  void killCreature(SuperCreature c) {
    c.kill();
  }

  void killAll() {
    creatures.clear();
    // TODO:
    // the previewCreature needs to get out from the main array 
    // to avoid code like this:
    currentCreature--;
    selectNextCreature();
  }

  void killCreatureByName(String creatureName) {
    for (SuperCreature c : creatures) {
      String name = c.creatureName;
      if (creatureName.equals(name)) creatures.remove(creatures.indexOf(c));
    }
  }

  void loop(color colorCreature) {

    
    
    
    if (showAbyssOrigin) {
      noFill();
      stroke(255, 0, 0);
      repere(200) ;
    }
    if (previewCreature != null) {
      previewCreature.setPos(releasePoint);
      previewCreature.energy = 10.0;
    }
    for (SuperCreature c : creatures) {
      //println(c.creatureName + " " + c.getPos()) ;      
      c.preDraw();
      c.move();      
      c.draw(colorCreature);
      c.postDraw();
    }
    

    
    drawOverlays();


    cleanUp();
  }

  void drawOverlays() {
    //separated from the main draw loop
    if (showCreatureAxis) {
      for (SuperCreature c : creatures) {  
        c.drawAxis();
      }
    }
    
    //reset camera
    //cameraDraw() ;
    

    //info
    if (previewCreature != null && showAbyssOrigin) for (SuperCreature c : creatures) previewCreature.drawInfo(c.getPos());

    if (showCreatureInfo) {
      for (SuperCreature c : creatures) {
        //c.getPos() ;      
        if (c != previewCreature) c.drawInfo(c.getPos());
      }
    }

    if (showManagerInfo) {
      showInfo(g);
    }
  }

  void cleanUp() {
    //remove dead cratures
    Iterator<SuperCreature> itr = creatures.iterator();
    while (itr.hasNext ()) {
      SuperCreature c = itr.next();
      if (c.getEnergy() <= 0) itr.remove();
    }
  }

  void addRandomCreature() {
    int r = floor(random(creatureClasses.size()));
    addCreature(r);
  }

  public SuperCreature addCurrentCreature() {
    if (currentCreature != -1) {
      previewCreature = addCreature(currentCreature);
    }
    return previewCreature;
  }

  public void setCurrentCreature(int i) {
    currentCreature = i;  
    if (currentCreature < -1 || currentCreature > creatureClasses.size()) {
      currentCreature = -1;
    }
    if (currentCreature > -1) {
      if (previewCreature != null) {
        previewCreature.kill();
        previewCreature = null;
      }
      if (currentCreature > -1) {
        previewCreature = addCreature(currentCreature);
      } 
      else {
        if (previewCreature != null) previewCreature.kill();
        previewCreature = null;
      }
    }
    else {
      if (previewCreature != null) {
        previewCreature.kill();
        previewCreature = null;
      }
    }
  }

  public void selectNextCreature() {
    if (creatureClasses.size() > 0) {
      currentCreature = ++currentCreature % creatureClasses.size();     
      setCurrentCreature(currentCreature);
    }
  }

  public void selectPrevCreature() {
    if (creatureClasses.size() > 0) {
      currentCreature--;
      if (currentCreature < 0) currentCreature = creatureClasses.size()-1;
      setCurrentCreature(currentCreature);
    }
  }

  public void toggleManagerInfo() {
    showManagerInfo = !showManagerInfo;
  }

  public void toggleCreatureInfo() {
    showCreatureInfo = !showCreatureInfo;
  }

  public void toggleAbyssOrigin() {
    showAbyssOrigin = !showAbyssOrigin;
  }

  public void toggleCreatureAxis() {
    showCreatureAxis = !showCreatureAxis;
  }

  public void prevCameraCreature() {
    if (creatures.size() > 0) {
      
      currentCameraCreature--;
      //security for the arraylist !
      if (currentCameraCreature < 0) currentCameraCreature = creatures.size()-1;
      newTarget = creatures.get(currentCameraCreature).getPos() ;
      initFollow(newTarget, getEyeCamera()) ;
    } else {
      currentCameraCreature = -1;
    }
  }


  public void nextCameraCreature() {
    if (creatures.size() > 0) {
      
      currentCameraCreature = ++currentCameraCreature % creatures.size();
      newTarget = creatures.get(currentCameraCreature).getPos() ;
      initFollow(newTarget, getEyeCamera()) ;
    } 
    else {
      currentCameraCreature = -1;
    }
  }
}
