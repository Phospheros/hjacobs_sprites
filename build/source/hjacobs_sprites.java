import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class hjacobs_sprites extends PApplet {

//import java.io.File;
// int count = 1;
float x, y;
String name;
int index;
PImage[] sprites;
StringList imageList, figuresList, figuresUnique;
IntList figuresIndex;
Animation animation = new Animation(name, index, x, y);
Animation[] animationArray;

// ================= Setup ================= //

public void setup() {
  

  java.io.File spritesFolder = new java.io.File(dataPath("Sprites"));           // data/Sprites
  String[] files = spritesFolder.list();                                        // All files (including invisibles).
  imageList = new StringList();                                                 // Images array.
  figuresList = new StringList();                                               // Figures list ref. (but not frames).
  figuresIndex = new IntList();

  sprites = new PImage[files.length];

  int appendCount = 0;  // Used to access image array[], which may be different from files[i].
  for (int i = 0; i < spritesFolder.list().length; i++) {                       // All files...
    if ( files[i].toLowerCase().endsWith(".png")) {                             // ... only images.
      imageList.append(files[i]);                                               // Build image array.
      sprites[i] = loadImage("Sprites/" + imageList.get(appendCount));
      // println(imageList.get(appendCount));                                   // Debug.
      // println(sprites[i]);
      appendCount++ ;
    }
  }

  figuresList = imageList.copy();                                               // Build list of figures
  String substring;                                                             // by cutting suffix info, and
  String trimmed;                                                               // leaving only prefix,

  for(int i = 0; i < figuresList.size(); i++) {
    substring = figuresList.get(i).substring(8, 20);
    //println(substring);
    trimmed = figuresList.get(i).replace(substring, "");
    figuresList.set(i, trimmed);                                                // resulting here. Then,
    //println(figuresList.get(i));
  }

  for(int i = 0; i < figuresList.size(); i++ ) {
    figuresIndex.appendUnique(figuresList.index(figuresList.get(i)));           // find unique figures index, and
  }

  String[] figuresUnique = figuresList.getUnique();                             // create array exclusive of duplicates.




  animationArray = new Animation[figuresUnique.length];
  for(int i = 0; i < figuresUnique.length; i++ ) {
    animation.name = figuresUnique[i];
    animation.index = figuresIndex.get(i);
    animation.x = width/2;
    animation.y = height/2;
    animationArray[i] = new Animation(animation.name, animation.index, animation.x, animation.y);
  }



  imageMode(CENTER);
  frameRate(30);
  background(255);
  // println(files.length);
  // println(imageList.size());
  // println(animationArray.length);
  // println(figuresList);
  // println(figuresUnique);
  // println(figuresIndex);
  // exit();
}

// ================= Draw ================= //


public void draw() {
  background(255);

  for(int i = 0; i < animationArray.length; i++) {
    animationArray[i].show();
    animationArray[i].move();
    animationArray[i].scatter();

    //println(animationArray[i].name);
    //println(animationArray[i].index);
    // println(animationArray[0].inc + "  " + animationArray[0].count);
    // println(animationArray[0].rate);
  }
  // println(animationArray[0].inc + "  " + animationArray[0].count);
  // println(int(frameRate) + " fps" + " " + frameCount + " frames");
}

/* ======= Class ======= */

class Animation {
  String name;
  int index;
  float x, y;
  int count;
  int d = 75 / 2;                                                               // Sprite .png is 75 X 75, but lots of background padding.
  float vRange = 3;                                                             // Velocity & heading variables...
  float vx = random(-vRange, vRange);                                           // ... setting x velocity, ...
  float vy = vx * random(-2, 2);                                                // ... and then y as ratio to constrain away from vertical movement.
  int facing;                                                                   // Image orientation, left or right.
  float field, dx, dy, lerpVal, lerpX, lerpY;                                   // Scatter force field variables.
  float ease = 30;                                                              // Force field. Lower vals. are stronger.
  float r = 400;                                                                // Radius of force field.
  int inc = 0;                                                                  // Rate variable controls individual animation frame rate...
  int rate;                                                                     // 1 :: 1 is fastest, 1 :: n > 1 is slower.
  int resetInc = 0;                                                             // Animation reset counter.
  int reset = (PApplet.parseInt(random(1000)));                                              // Animation reset probability.

  Animation(String name, int index, float x, float y) {
    this.name = name;
    this.index = index;
    this.x = x;
    this.y = y;
  }

  public void show() {

    rate = (field <= r && mousePressed) ? 1 : floor(abs(vx)) * -1 + PApplet.parseInt(vRange);  // Rate as function of vx.
    // rate = (mousePressed) ? 1 : floor(abs(vx) + abs(vy)) * -1 + int(vRange + 2);  // Rate as function of vx, vy Manhatten.
    // rate = (mousePressed) ? 1 : floor(dist(0, 0, vx, vy)) * -1 + int(vRange + 2); // Rate as function of vx, vy Euclidean.
    rate = constrain(rate, 1, rate);

    count = (imageList.get(index + count).contains(name)) ? count : 0;
    pushMatrix();
    scale(facing, 1);                                                           // Flip image.
    image(sprites[index + count], x * facing, y);                               // sprites[], imageList() off by 1.
    popMatrix();
    // println(name + "  " + index + "  " + count + "  " + imageList.get(index + count));
    // println(index + count);
    // println(count);
    // println(imageList.size());

    inc++ ;
    if (inc % rate == 0) count++ ;                                              // Animate per rate setting.
    if (inc % imageList.size() == 0) inc = 0;
    if(index + count >= sprites.length - 1) count = 0;                          // Keep sprites in bounds (array).

    textSize(12);                                                               // Display sprite ID.
    fill(0);
    textAlign(CENTER);
    text(name, x, y + d + 6);

  }

  public void move() {
    x += vx;
    y += vy;

    vx = (x > width - d || x < 0 + d) ? -vx : vx;                               // Edge rebound.
    vy = (y > height - d || y < 0 + d) ? -vy : vy;
    x = constrain(x, 0 + d, width - d);
    y = constrain(y, 0 + d, height - d);

    facing = (vx < 0) ? 1 : -1;                                                 // Orient image w/travel direction.
    if (x <= 0 || x >= width) facing *= -1;                                     // Rebound orientation.

    resetInc++ ;                                                                // Random delayed Brownian motion.
    if (resetInc % reset == 0 && !(x <= 0 + d) && !(x >= width - d)) {          // (Avoid reset at edges, or fibrillation may occur.)
      vx = random(-vRange, vRange);
      vy = vx * random(-2, 2);
      resetInc = 0;
      reset = (PApplet.parseInt(random(1, 100)));
    }

  }

  public void scatter() {
    field = dist(mouseX, mouseY, x, y);                                         // Locus / particle distance.
    lerpVal = r / field;                                                        // Field radius / distance.
    lerpX = lerp(mouseX, x, lerpVal);                                           // Fractional distance.
    lerpY = lerp(mouseY, y, lerpVal);

    if (field <= r && mousePressed) {
      stroke(0, 50);
      line(x, y, lerpX, lerpY);                                                 // Trajectory display.
      dx = lerpX - x;                                                           // Velocity as factor of distance.
      dy = lerpY - y;
      x += dx/ease;                                                             // Apply velocity.
      y += dy/ease;
      x = constrain(x, 0 + d, width - d);
      y = constrain(y, 0 + d, height - d);

      facing = (dx < 0) ? 1 : -1;                                               // Orient image w/travel direction, scatter specific.
      if (x <= 0 || x >= width) facing *= -1;                                   // Rebound orientation.

    }
  }

}

/*  =========== Notes =========== /

Projector resolution = 1920 X 1080, throw ~= 132" X 73" @ ~110" distance.

Remember to turn off cursor display, and scatter lines visuals in production.

Issues:

Reset occasionally introduces facing fibrillation. Once sprite size is finalized, fix this by not resetting at edge (presumably).

Consider restarting entire sketch periodically.

*/
  public void settings() {  size(1000, 1000, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "hjacobs_sprites" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
