/**
 * An OpenGL fog wrapper.
 * This implementation works only until Processing 1.5.1
 */
import javax.media.opengl.GL;
import java.nio.FloatBuffer;

class Fog {
  PApplet parent;
  float near = 100;
  float far  = 1000;
  float damp = 0.01;
  float r, g, b, dr, dg, db;
  boolean useBackground = false;

  Fog(PApplet p, float near, float far, color col) {
    this.parent = p;
    this.near = near;
    this.far = far;
    setColor(col);
    fog(near, far, col);
  }
  
  void fadeTo(color col, float damp) {
    this.damp = damp;
    fadeTo(col);
  }

  void fadeTo(color col) {
    dr = red(col);
    dg = green(col);
    db = blue(col);
  }
  
  void setColor(float r, float g, float b){
    setColor(color(r,g,b));
  }
  
  void setColor(color col) {
    dr = red(col);
    dg = green(col);
    db = blue(col);  
    r = dr;
    g = dg;
    b = db;
  }

  color getColor() {
    return color(r, g, b);
  }

  void apply() {
    r += (dr - r) * damp;
    g += (dg - g) * damp;
    b += (db - b) * damp;
    color col = color(r, g, b);
    if (useBackground) parent.background(col);
    fog(near, far, col);
  }
  
  void noFog() {
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) parent.g;
    GL gl = pgl.beginGL();
    gl.glDisable(GL.GL_FOG); 
    pgl.endGL();
  }

  void fog(float near, float far, color col) {
    float[] fogColor = new float[4];
    fogColor[0] = red(col)   / 255.0;
    fogColor[1] = green(col) / 255.0;
    fogColor[2] = blue(col)  / 255.0;
    fogColor[3] = alpha(col) / 255.0;  

    PGraphicsOpenGL pgl = (PGraphicsOpenGL) parent.g;
    GL gl = pgl.beginGL();
    gl.glEnable(GL.GL_FOG); 
    gl.glFogi(GL.GL_FOG_MODE, GL.GL_LINEAR);
    gl.glFogf(GL.GL_FOG_START, near);
    gl.glFogf(GL.GL_FOG_END, far);
    gl.glFogfv(GL.GL_FOG_COLOR, FloatBuffer.wrap(fogColor)); 
    gl.glHint(GL.GL_FOG_HINT, GL.GL_NICEST);
    pgl.endGL();
  }
}
