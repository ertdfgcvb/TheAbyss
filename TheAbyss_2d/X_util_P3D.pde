//BACKGROUND
////////////
void backgroundP3D(color c, int o) {
  fill(c,o) ;
  noStroke() ;
  pushMatrix() ;
  final PVector sizeBG = new PVector(width *100, height *100) ;
  translate(-sizeBG.x *.5,-sizeBG.y *.5 , -3100) ;
  rect(0,0, sizeBG.x,sizeBG.y) ;
  popMatrix() ;
}
//END BACKGROUND


//REPERE 3D
void repere(int size, PVector pos, String name)
{
  pushMatrix() ;
  translate(pos.x +20 , pos.y -20, pos.z) ;
  fill(blanc) ;
  text(name, 0,0) ;
  popMatrix() ;
  line(-size +pos.x,pos.y, pos.z,size +pos.x, pos.y, pos.z) ;
  line(pos.x,-size +pos.y, pos.z, pos.x,size +pos.y, pos.z) ;
  line(pos.x, pos.y,-size +pos.z, pos.x, pos.y,size +pos.z) ;
}

void repere(int size)
{
  line(-size,0,0,size,0,0) ;
  line(0,-size,0,0,size,0) ;
  line(0,0,-size,0,0,size) ;
}
//END REPERE 3D
