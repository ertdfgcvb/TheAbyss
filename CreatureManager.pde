class CreatureManager {
  private ArrayList<SuperCreature>creatures;
  private ArrayList<Class>creatureClasses;
  SuperCreature mouseCreature;  
  PApplet parent;
  String infoText;
  
  int currentCreature = -1;
  boolean showCreatureInfo = false;
  boolean showManagerInfo = true;
  boolean showGrid = false;
  boolean highTextQuality = false;
  int gridCellSize = 180;
  int gridOffs = 25;

  CreatureManager(PApplet parent) {
    PFont fnt = loadFont("Monaco-12.vlw");
    textFont(fnt);
    textLeading(15);
    this.parent = parent;
    creatures = new ArrayList<SuperCreature>();
    scanClasses();
  }

  private void scanClasses() {
    println("--- SCANNING CREATURE CLASSES ---");
    creatureClasses = new ArrayList<Class>();
    infoText = "";
    Class[] c = parent.getClass().getDeclaredClasses();
    for (int i=0; i<c.length; i++) {
      if (c[i].getSuperclass().getSimpleName().equals("SuperCreature")) {
        creatureClasses.add(c[i]);
        int n = creatureClasses.size()-1;
        String numb = str(n);
        if (n < 10) numb = " " + n;
        infoText += numb + "      " + c[i].getSimpleName() + "\n";
      }
    }
    println(infoText);
  }
  public void showCreatureInfo() {
    for (SuperCreature c : creatures) {
      c.showInfo();
    }
  }

  ArrayList<SuperCreature> getCreatures() {
    return creatures;
  }

  /*
   two main draw loops: a grid mode or a free "bio" mode
   */
  public void drawBio() {
    for (SuperCreature c : creatures) {      
      c.move();
      if (c == mouseCreature) {
        mouseCreature.setPos(new PVector(mouseX, mouseY, 0));
      }
      c.preDraw();
      c.draw();
      c.postDraw();
      if (showCreatureInfo || (c == mouseCreature && showManagerInfo)) c.showInfo();
    }
    if (showManagerInfo) showInfo();
  }

  public void drawGrid() {
    int numV = (height-gridOffs) / gridCellSize;
    rectMode(CORNER);
    int i=0;
    for (SuperCreature c : creatures) {
      c.move();
      int px = i / numV * gridCellSize  + gridOffs;
      int py = i % numV * gridCellSize  + gridOffs;
      PVector v = new PVector(px + gridCellSize/2, py + gridCellSize/2);
      c.setPos(v);
      c.preDraw();
      c.draw();
      c.postDraw();
      noFill();
      stroke(255);
      rect(px, py, gridCellSize, gridCellSize);
      i++;
    }
  }  

  public void showInfo() {
    fill(255);
    noStroke();
    String s = "";
    s += "        the abyss\n";
    s += "        2010-2011\n";
    s += "------------------------------------\n";
    s += "fps     " + round(frameRate) + "\n";
    s += "num     " + creatures.size() + "\n";
    s += "------------------------------------\n";
    s += infoText;
    s += "------------------------------------\n";
    s += "g       toggle grid\n";
    s += "b       toggle backdrop\n";
    s += "i       toggle info\n";
    s += "c       toggle creature info\n";   
    s += "arrows  next/prev creature\n";   
    s += "space   kill all!\n";
    text(s, 10, 20);
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
      addCreature(f);
    }
    return f;
  }

  /// MAIN ADD ///  
  void addCreature(SuperCreature c) {
    c.setManagerReference(this);
    creatures.add(c);
    tellAllThatCreatureHasBeenAdded(c);
  }

  // the killing section -- added by fabian frei // hyperwerk
  // --------------------------------------------------------
  void tellAllThatCreatureHasBeenAdded(SuperCreature cAdded) {
    for (SuperCreature c : creatures) {
      c.creatureHasBeenAdded(cAdded);
    }
  }
  /*
  Renamed from killMyself to killCreature 
  A. Gysin
  */
  void killCreature(SuperCreature c) {
   int i = creatures.indexOf(c);
   if (i >= 0) creatures.remove(i); //Fabian: I Added this test as the function could eventually cause a Bug!
  }

  void killAll() {
    if (!showGrid) {
      creatures.clear();
    }
  }

  // the killing section -- added by fabian frei // hyperwerk
  // --------------------------------------------------------

  void killCreatureByName(String creatureName) {
    for (SuperCreature c : creatures) {
      String name = c.creatureName;
      if (creatureName.equals(name)) creatures.remove(creatures.indexOf(c));
    }
  }//END: killCreatureByName

  /*
  commented by A.Gysin 
   bad practice:
   let's handle all key & mouse events in the main class
   void addCreatureByPressingNumber() {
   if (keyPressed) {
   int r = (int) key;       
   addCreature(r - 48);
   //println((int) key);
   }
   } //END: addCreatureByPressingNumber  
   */

  void draw() {
    
    if (showGrid) {
      drawGrid();
    } 
    else {
      drawBio();
    }
  }

  void addRandomCreature() {
    int r = floor(random(creatureClasses.size()));
    addCreature(r);
  }

  public SuperCreature addCurrentCreature() {
    if (currentCreature != -1) {
      mouseCreature = addCreature(currentCreature);
    } 
    return mouseCreature;
  } 

  public void setCurrentCreature(int i) {
    currentCreature = i;  
    if (currentCreature < -1 || currentCreature > creatureClasses.size()) {
      currentCreature = -1;
    }
    if (currentCreature > -1) {
      if (mouseCreature != null) mouseCreature.kill();
      if (currentCreature > -1) {
        mouseCreature = addCreature(currentCreature);
      } 
      else {
        if (mouseCreature != null) mouseCreature.kill();
        mouseCreature = null;
      }
    } 
    else {
      if (mouseCreature != null) mouseCreature.kill();
    }
  } 

  public void selectNextCreature() {
    if (!showGrid) {
        currentCreature++;
        if (currentCreature == creatureClasses.size()) currentCreature = -1;
        setCurrentCreature(currentCreature);
    }
  }
  
  public void selectPrevCreature() {
    if (!showGrid) {
        currentCreature--;
        if (currentCreature < -1) currentCreature = creatureClasses.size()-1;
        setCurrentCreature(currentCreature);
    }
  }

  public void toggleManagerInfo() {
    showManagerInfo = !showManagerInfo;
  }

  public void toggleCreatureInfo() {
    showCreatureInfo = !showCreatureInfo;
  }

  public void toggleGrid() {
    showGrid = !showGrid;
    creatures.clear();
    setCurrentCreature(-1);
    if (showGrid) {
      for (int i=0; i<creatureClasses.size(); i++) {
        addCreature(i);
      }
    }
  }
}

