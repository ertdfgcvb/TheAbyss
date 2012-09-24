/**
 * The core class.
 * Takes care of instantiating creatures and makes them live and die.
 */
class CreatureManager {
  private ArrayList<SuperCreature>creatures;
  private ArrayList<Class>creatureClasses;
  private CreatureCamera cam;

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
    releasePoint = getRandomVect();
    creatures = new ArrayList<SuperCreature>();
    cam = new CreatureCamera();
    cam.eye.z = 50;
    scanClasses();
  }

  //reflexion
  private void scanClasses() {
    println("--- SCANNING CREATURE CLASSES ---");
    creatureClasses = new ArrayList<Class>();
    infoText = "";
    Class[] c = parent.getClass().getDeclaredClasses();
    for (int i=0; i<c.length; i++) {
      if (c[i].getSuperclass() != null && (c[i].getSuperclass().getSimpleName().equals("SuperCreature") )) {
        creatureClasses.add(c[i]);
        int n = creatureClasses.size()-1;
        String numb = str(n);
        if (n < 10) numb = " " + n;
        infoText += numb + "         " + c[i].getSimpleName() + "\n";
      }
    }
    println(infoText);
  }
  public void showCreatureInfo() {
    for (SuperCreature c : creatures) {
      c.showInfo();
    }
  }

  public void showInfo() {
    fill(255);
    noStroke();
    String s = "";
    s += "           the abyss v.2\n";
    s += "           2012\n";
    s += "------------------------------------\n";
    s += "fps        " + round(frameRate) + "\n";
    s += "num        " + creatures.size() + "\n";
    s += "------------------------------------\n";
    s += infoText;
    s += "------------------------------------\n";
    s += "left/right next/prev creature\n";   
    s += "space      add current creature\n";   
    s += "up/down    next/prev creature cam\n";   
    s += "return     current creature cam\n";
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
      releasePoint = getRandomVect();
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
  }

  void killCreatureByName(String creatureName) {
    for (SuperCreature c : creatures) {
      String name = c.creatureName;
      if (creatureName.equals(name)) creatures.remove(creatures.indexOf(c));
    }
  }

  void draw() {
    hint(ENABLE_DEPTH_TEST);
    cam.apply();

    if (showAbyssOrigin) {
      noFill();
      stroke(255, 0, 0);
      box(200, 200, 200);
    }

    if (previewCreature != null) previewCreature.setPos(releasePoint);

    for (SuperCreature c : creatures) {      
      c.preDraw();
      c.move();
      c.draw();
      c.postDraw();
    }
    
    //separated from the main draw loop
    if (showCreatureAxis) {
      for (SuperCreature c : creatures) {  
        c.showAxis();
      }
    }

    //reset camera
    camera();
    hint(DISABLE_DEPTH_TEST);

    //info
    if (previewCreature != null && showAbyssOrigin) previewCreature.showInfo();
    
    if (showCreatureInfo) {
      for (SuperCreature c : creatures) {      
        if (c != previewCreature) c.showInfo();
      }
    }

    if (showManagerInfo) {
      showInfo();
    }

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
    currentCreature++;
    if (currentCreature == creatureClasses.size()) currentCreature = -1;
    setCurrentCreature(currentCreature);
  }

  public void selectPrevCreature() {
    currentCreature--;
    if (currentCreature < -1) currentCreature = creatureClasses.size()-1;
    setCurrentCreature(currentCreature);
  }

  private PVector getRandomVect() {
    float l = random(100);
    PVector r = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    r.normalize();
    r.mult(l);
    return r;
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
      if (currentCameraCreature < 0) currentCameraCreature = creatures.size()-1;
      cam.setTargetCreature(creatures.get(currentCameraCreature));
      cam.setCameraMode(CreatureCamera.CREATURE_CAM);
    } 
    else {
      currentCameraCreature = -1;
      cam.setCameraMode(CreatureCamera.DEFAULT_CAM);
    }
  }

  CreatureCamera getCamera() {
    return cam;
  }

  public void currentCameraCreature() {
    if (previewCreature != null) {
      cam.setTargetCreature(previewCreature);
      cam.setCameraMode(CreatureCamera.CREATURE_CAM);
    }
  }

  public void nextCameraCreature() {
    if (creatures.size() > 0) {
      currentCameraCreature = ++currentCameraCreature % creatures.size();
      cam.setTargetCreature(creatures.get(currentCameraCreature));
      cam.setCameraMode(CreatureCamera.CREATURE_CAM);
    } 
    else {
      currentCameraCreature = -1;
      cam.setCameraMode(CreatureCamera.DEFAULT_CAM);
    }
  }
}

