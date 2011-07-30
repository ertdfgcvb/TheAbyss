class FBFader extends SuperCreature {

  private float radius;
  private float theta;
  private PVector acceleration;
  private PVector velocity;
  private PVector dest;
  private float xmove;
  private float ymove;

  public FBFader() {
    
    creatureName = "Fader";
    creatureAuthor = "Filip Bielejec";
    creatureVersion = "beta";

    pos = new PVector(random(width), random(height));   
    dest = new PVector(random(width), random(height));
    
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);	
    
    theta = 0;   
   
  }//END: FBFader()

  void move() {  
    
    dest.x +=random(-3,3);
    dest.y +=random(-3,3);
    
    pos.x += (dest.x - pos.x)*0.01;
    pos.y += (dest.y - pos.y)*0.01;
    
    pos.x = constrain(pos.x, 2 * radius, width - 2 * radius);
    pos.y = constrain(pos.y, 2 * radius, height - 2 * radius);
    
  }//END: move

  void draw() {
   
  radius = 20;
    
  smooth();  
  noFill();
  strokeWeight(0.001);
  stroke(255, 255, 255, 25);
   
  translate(pos.x, pos.y);  
  rotateY(cos(0.3 * theta));
  rotateX(sin(0.3 * theta));
  rotateZ(cos(0.3 * theta));
  
  sphere(radius);
  //sphereDetail(10);
  drawTentacles();
  
  theta = theta + 0.1;
  
  
  SuperCreature nc = getNearest();
if(nc != null && getEuclidianDistance(pos, nc.getPos() ) < 2 * radius) {
  
  stroke(255, 255, 255, random(10, 70));// 124, 250, 188,
  sphere(radius);
  drawTentacles();
  
  if(!nc.creatureName.equals("Fader")) {

    circleAround(nc);
  
     } 
    }    
  }//END: draw
  
  void drawTentacles() {
  
  int numSegments = 10;
  int numTentacles = 6;
  float tentLength = 7;
    
    for (int j = 0; j < numTentacles; j++) {
    
    pushMatrix();
    float a = (noise(frameCount * 0.004 + j)-0.5) * 0.62; 

    for (int i = 0; i < numSegments; i++) {
      rotateZ(a);
      translate(tentLength * 0.9, 0, 0);
      scale(0.95, 0.95, 0.95);
      box(tentLength, tentLength/2, tentLength/2);
    }
    
    popMatrix();
    rotateY(TWO_PI / numTentacles);
    }  
  }//END: draw tentacles
  
void circleAround(SuperCreature nc) {                                                                        
                                                                           
  PVector prayPos = nc.getPos();
  PVector dir = PVector.sub(prayPos, pos);                               
                                                                           
  dir.normalize();
  dir.mult(0.5);
  acceleration = dir;
                                 
  velocity.add(acceleration); 
  velocity.limit(20);
  pos.add(velocity);
  
}//END: circleAround
  
void trace(int strenght) {  
  fill(0, 0, 0, strenght);
  ellipse(pos.x, pos.y, radius, radius);

}//END: fade



/*
edited by A. Gysin
you could use the vector method: p1.dist(p2);

edited by F. Bielejec
you got it mate!
*/
float getEuclidianDistance(PVector p1, PVector p2) {
  float distance = p1.dist(p2);
  
  return distance;
  }//END: getEuclidianDistance

 
}//END: class

                                                                    


