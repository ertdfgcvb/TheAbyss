class BackdropManager {

  PApplet parent;

  // ArrayList<SuperBackDrop> backDrops = new ArrayList<SuperBackDrop>();
  int backdropIndex = -1;


  SuperBackdrop currentBackdrop;
  BackdropManager( PApplet parent) {
    this.parent = parent;
    nextBackDrop();
  }


  /* ---------- BackDrop Stuff written by fabian frei // hyperwerk.ch -------- */
  /* 
   private void addBackDrops()
   {
   backDrops.add(new backDropPoint());
   }
   */

  private void nextBackDrop() {
    backdropIndex = ++backdropIndex%3;    
    if (backdropIndex == 0) currentBackdrop = new BackdropPlain();
    else if (backdropIndex == 1) currentBackdrop = new BackdropFade();
    else if (backdropIndex == 2) currentBackdrop = new BackdropBlue();
  }

  void draw() {
    pushStyle();
    if (currentBackdrop != null) {  
      // currentBackdrop.update();
      currentBackdrop.draw();
    } 
    else {
      background(255, 0, 0);
    }
    popStyle();
  }

  /* ---------- BackDrop Stuff written by fabian frei // hyperwerk.ch -------- */
}


