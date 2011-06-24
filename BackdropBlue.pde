class BackdropBlue extends SuperBackdrop {
  void draw() {
    noStroke();
    background(0);
    beginShape();

    float b1 = sin(frameCount*0.013) * 127 + 128;
    float b2 = sin(frameCount*0.015) * 127 + 128;
    float b3 = sin(frameCount*0.017) * 127 + 128;
    float b4 = sin(frameCount*0.019) * 127 + 128;

    fill(0, 0, b1); 
    vertex(0, 0);
    fill(0, 0, b2); 
    vertex(width, 0);
    fill(0, 0, b3); 
    vertex(width, height);
    fill(0, 0, b4); 
    vertex(0, height);

    endShape();
  }
}

