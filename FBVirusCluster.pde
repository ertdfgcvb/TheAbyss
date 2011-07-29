class FBVirusCluster extends SuperCreature {
  
  int numViruses = 700;
  ArrayList <Virus> viruses;
  PVector dest;

  public FBVirusCluster() {

    creatureName = "VirusCluster";
    creatureAuthor = "Filip Bielejec";
    creatureVersion = "1.0";
  	
    viruses = new ArrayList<Virus>();
    dest = new PVector(random(width), random(height));	    

    for(int i = 0; i < numViruses; i++) {
    	
        viruses.add(new Virus(
        new PVector(
        random(0, width ), 
        random(0, height)),
        new PVector(0, 0),
        new PVector(0, 0),
        10000)
        );
    }

}//END: setup

  void move() {

 if (random(1) < random(0.01, 0.05)) {
   
      dest.x += random(-100, 100);
      dest.y += random(-100, 100);

      dest.x = constrain(dest.x, 100, width - 100);
      dest.y = constrain(dest.y, 100, height - 100);
    }

    pos.x += (dest.x - pos.x) * 0.02;
    pos.y += (dest.y - pos.y) * 0.02;
      
  }//END: move   

  void draw() {
  
    smooth();
    stroke(255, 255, 255);
    
 for(Iterator it = viruses.iterator(); it.hasNext();) {
    	
        Virus v = (Virus)it.next();
        v.draw();
        
    }
    
 for(Iterator it = viruses.iterator(); it.hasNext();) {
    	
        Virus v = (Virus) it.next();
        v.pulse(random(0.001, 0.005));
        
    }  

SuperCreature nc = getNearest();
if(nc != null && !nc.creatureName.equals("VirusCluster")  && getEuclidianDistance(pos, nc.getPos() ) < 30) {

 for(Iterator it = viruses.iterator(); it.hasNext();) {
    	   
        Virus v = (Virus) it.next();
        
        pos.x = Math.abs(pos.x - getNearest().pos.x)  * (-1);  
        pos.y = Math.abs(pos.y - getNearest().pos.y) * (-1);  
        v.acceleration.set(0, 0, 0);
        
      }  
    }   
  }//END: draw
  
float getEuclidianDistance(PVector p1, PVector p2) {
  float distance = p1.dist(p2);
  
  return distance;
  }

  class Virus {

    PVector location;
    PVector velocity;
    PVector acceleration;
    float sensitivity;

    Virus(PVector l, PVector v, PVector a, float s) {

      location = l;
      velocity = v;
      acceleration = a;
      sensitivity = s;
      
    }
    
   void draw() {
      
      acceleration.limit(5);
      velocity.add(acceleration);

      velocity.limit(10);
      location.add(velocity);

      point(location.x, location.y);
    
    }//END: draw

  
  void pulse(float modifier) { 
    
     PVector position = new PVector(pos.x, pos.y);

      float distance = position.dist(location);

        PVector tmp = PVector.sub(position, location);

        tmp.normalize();

        tmp.mult(modifier * (sensitivity - distance));

        acceleration = tmp;
        
  }//END: pulse
  
    
  }//END: Virus class

}//END: VirusCluster class

