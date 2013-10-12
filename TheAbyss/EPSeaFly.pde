class EPSeaFly extends SuperCreature {

  PVector freqMulPos, freqMulAng;
  int count;

  public EPSeaFly() {
    creatureName = "EPSeaFly";
    creatureAuthor = "Edoardo Parini";
    creatureVersion = "1.0";
    setDate(2012, 4, 25);

    freqMulPos = new PVector();
    freqMulPos.x = random(-0.002, 0.002); 
    freqMulPos.y = random(-0.002, 0.002); 
    freqMulPos.z = random(-0.002, 0.002);

    freqMulAng = new PVector();
    freqMulAng.x = random(-0.005, 0.005); 
    freqMulAng.y = random(-0.005, 0.005); 
    freqMulAng.z = random(-0.005, 0.005);
  }

  void move() {
    count++;
    pos.x += sin(count*freqMulPos.x);
    pos.y += sin(count*freqMulPos.y);
    pos.z += cos(count*freqMulPos.y);

    rot.x = sin(count*freqMulAng.x) * TWO_PI;
    rot.y = sin(count*freqMulAng.y) * TWO_PI;
    rot.z = sin(count*freqMulAng.z) * TWO_PI;
    
    applyTransforms();
  }

  void draw() {

    stroke(255);
    noFill();  
    float dimR = 20;
    float dimF = 10;  

    scale(0.2);
    translate(count * 0.018, count * 0.008); 
    rotateX(count * 0.008);

    PVector dim = new PVector(100, 60, 30);
    fill(255);
    sphereDetail(3); 
    sphere(25);

    float aF = sin(count * 0.15) * 0.8;  
    float aR = sin(count * 0.25) * 0.8;

    pushMatrix();                            
    translate(-dim.x/2, dim.y/2, dim.z/2);
    rotateZ(aF/2 + 1.2);
    rotateY(aF - 1);
    fill(255,150);
    quad(0, 0, 86, 20, 69, 63, 30, 76);
    noFill();
    quad(0, 0, 96, 23, 79, 73, 40, 86);
    popMatrix();

    pushMatrix();                          
    translate(-dim.x/2, dim.y/2, -dim.z/2);
    rotateZ(aF/2 + 1.2);
    rotateY(-aF + 1);
    fill(255,150);
    quad(0, 0, 86, 20, 69, 63, 30, 76);
    noFill();
    quad(0, 0, 96, 23, 79, 73, 40, 86);
    popMatrix();

    pushMatrix();                          
    translate(dim.x/2, dim.y/2, dim.z/2);
    rotateY(aR);
    quad(0, 0, 96, 23, 79, 73, 40, 86);
    fill(255,150);
    quad(0, 0, 86, 20, 69, 63, 30, 76);
    popMatrix();

    pushMatrix();                  
    translate(dim.x/2, dim.y/2, -dim.z/2);
    rotateY(-aR);
    quad(0, 0, 86, 20, 69, 63, 30, 76);
    noFill();
    quad(0, 0, 96, 23, 79, 73, 40, 86);
    popMatrix();
  }
}

