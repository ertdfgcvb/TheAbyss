/*
 Backdrop Class
 by
 Fabian Frei // HyperWerk 2011
 
 You need to add your Class to the CreatureManager by hand!
 
 Have fun
 If you read that you have to buy me a drink ;)
 */

abstract class SuperBackdrop {

  protected PVector pos;
  protected String backdropName, backdropAuthor, backdropVersion;
  protected int vis;

  //abstract public void update();
  abstract public void draw(); // no background, it is called in the manager

  /* blending stuff
   //abstract public void setColor(); // set the color and use visibility as alpha value for automatic blend in and out
   public void blend(int vis)
   {
   this.vis = vis;
   }
   */

  public SuperBackdrop() {

    backdropName = "Unknown";
    backdropAuthor = "Anonymous";
    backdropVersion = "1.0";
  }//END: SuperBackdrop()
}//END: SuperBackdrop

class BackdropPlain extends SuperBackdrop {
  void draw() {
    background(0);
  }
}

