class BackdropPlankton extends SuperBackdrop {

  int numViruses = 1000;
  ArrayList <Virus> viruses;
  int offset = 10; 
 
BackdropPlankton() {
  
  backdropName = "Plankton";
  backdropAuthor = "Filip Bielejec";
  backdropVersion = "1.0";
  
  viruses = new ArrayList<Virus>();
     
      for(int i = 0; i < numViruses; i++) {
    	
        viruses.add(new Virus(
        new PVector(
        random(0, width ), 
        random(0, height)),
        new PVector(0, 0),
        new PVector(0, 0),
        100)
        );
    }
    
}
 
void draw() {

//  background(0);
  
  //refresh();
 
    for(Iterator it = viruses.iterator(); it.hasNext();) {
        Virus p = (Virus)it.next();
        p.draw();
        p.disperse(0.0001);
    }
     
           
}//END: draw
 
void refresh() {
    fill(0);
    rect(0, 0, width, height);
}//END: refresh         
 
 
class Virus {
  
    PVector location;
    PVector velocity;
    PVector acceleration;
    float sensitivity;
 
 
    Virus(PVector l, PVector v, PVector a, float s){
        location = l;
        velocity = v;
        acceleration = a;
        sensitivity = s;
    }
 
    void draw() {
      
        stroke(255, random(50, 250)); 
        move();
        checkEdges();
        point(location.x, location.y);
        
    }
 
    void move() {
      
        location.x = constrain(location.x, offset, width - offset);
        location.y = constrain(location.y, offset, height - offset);
      
        acceleration.limit(10);
        velocity.add(acceleration);
        
        velocity.limit(10);
        location.add(velocity);
        
    }//END: move
 
     
    void disperse(float modifier) {
      
        //SuperCreature nc = getNearest();
        PVector np = new PVector(mouseX, mouseY);
        
        if(np != null) {
        
        //PVector np = nc.getPos();
      
        float distance = np.dist(location);
      
        if(distance < sensitivity){
      
          PVector dir = PVector.sub(np, location);
          dir.normalize();
          dir.mult(modifier * (-sensitivity + distance));
          acceleration = dir;
            
        } else {
          
            acceleration.set(0,0,0);
        }
      }  
  }//END: disperse
    
void checkEdges() {

  acceleration.set(1, 1, 1);
  
  if (location.x > width-offset) {
    location.x = 0;

  } else if (location.x < offset) {
    location.x = width-offset;

  }
  
  if (location.y > height-offset) {
    location.y = 0;
  
  } else if (location.y < offset) {
    location.y = height-offset;
  }
   
}//END: checkEdges

    
}//END: Virus class


}//END: BackdropPlankton class
