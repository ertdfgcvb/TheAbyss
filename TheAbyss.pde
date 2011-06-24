/**
 * The Abyss. 
 * A polymorphism workshop by Andreas Gysin. 
 * 2010-2011
 * I've used "The Abyss" to teach in two processing workshops for beginners and intermediate level.
 * It worked quite well so please feel free to use it for your teaching 
 * or just partecipate with your own creatures.
 * Please note that the structure was born during the workshops with different contributions from the students.
 * After five days about 50 creature-classes populated The Abyss.
 * Each creature is a single .PDE file so it was easy to add them to The Abyss (via reflection) and to share them.
 *
 * The rules:
 * Extend the SuperCreature class and build your own creature. 
 * Allowed colors are white with alpha shades. Not a strict rule.
 * Each creature must implement the "move()" and "draw()" methods. (see SuperCreature for details)
 * Transforms should use the pos, rot, sca vectors.
 * Animations can be timed with frames or actual time.
 * The name of the new creature class is built with the authors initals and the creature name; 
 * not an optimal naming convention but it works with 10-20 people.
 * The .pde file must have the same name of the class.
 * example: AGCubus
 * Insert your name, the creature name and the version in the constructor. (To do: annotations?)
 *
 */

import processing.opengl.*;
import java.lang.reflect.*;

CreatureManager creatureManager;
BackdropManager backdropManager;
void setup() {
  size(screenWidth, screenHeight, OPENGL);  
  //hint(ENABLE_OPENGL_4X_SMOOTH);
  hint(DISABLE_DEPTH_TEST);
  hint(DISABLE_OPENGL_ERROR_REPORT); 
  //hint(DISABLE_DEPTH_SORT);

  frameRate(60);
  creatureManager = new CreatureManager(this);
  backdropManager = new BackdropManager(this);
}

void draw() {
  backdropManager.draw();
  creatureManager.draw();
}

void mousePressed() {
  SuperCreature c = creatureManager.addCurrentCreature();
  if (c != null) c.setPos(new PVector(mouseX, mouseY, 0));
}

void keyPressed() { 
  //NEW KEYSTROKES: use left or right and click to add creatures
  if (key == ' ') creatureManager.killAll();
  else if (key == 'i') creatureManager.toggleManagerInfo();
  else if (key == 'c') creatureManager.toggleCreatureInfo();
  else if (key == 'g') creatureManager.toggleGrid();
  else if (keyCode == RIGHT) creatureManager.selectNextCreature();
  else if (keyCode == LEFT) creatureManager.selectPrevCreature();
  else if (key == 'b') backdropManager.nextBackDrop();
}

