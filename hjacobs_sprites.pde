//import java.io.File;
int count = 1;
float x, y;
String name;
int index;
PImage[] sprites;
StringList imageList, figuresList, figuresUnique;
IntList figuresIndex;
Animation animation = new Animation(name, index, x, y);
Animation[] animationArray;

// ================= Setup ================= //

void setup() {
  size(1000, 1000, P3D);

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
      //println(imageList.get(appendCount));                                    // Debug.
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
    animation.x = width/3 + i * 50;
    animation.y = height/2;
    animationArray[i] = new Animation(animation.name, animation.index, animation.x, animation.y);
  }



  imageMode(CENTER);
  frameRate(30);
  background(255);
  //println(files.length);
  //println(imageList.size());
  // println(animationArray.length);
  //println(figuresList);
  //println(figuresUnique);
  //println(figuresIndex);
}

// ================= Draw ================= //


void draw() {
  background(255);

  for(int i = 0; i < animationArray.length; i++) {
    animationArray[i].show();
    animationArray[i].move();
    animationArray[i].scatter();


    //println(animationArray[i].name);
    //println(animationArray[i].index);
  }
  // println(frameRate + " fps");
}

/* ======= Class ======= */

class Animation {
  String name;
  int index;
  float x, y;
  int count = 0;
  int d = 0;                                                                    // Sprite .png is 72 X 72, but lots of background padding.
  float vRange = 5;
  float vx = random(-vRange, vRange);
  float vy = vx * random(-2, 2);
  int facing;
  float field, dx, dy, lerpVal, lerpX, lerpY;
  float ease = 50;
  float r = 300;

  Animation(String name, int index, float x, float y) {
    this.name = name;
    this.index = index;
    this.x = x;
    this.y = y;
  }

  void show() {

    count = (imageList.get(index + count).contains(name)) ? count : 0;
    pushMatrix();
    scale(facing, 1);
    image(sprites[index + count + 1], x * facing, y);                           // sprites[], imageList() off by 1.
    popMatrix();
    //println(name + "  " + index + "  " + count + "  " + imageList.get(index + count));
    //println(index + count + 1);
    count++ ;
    if(index + count + 1 >= sprites.length) count = -1;                         // Keep sprites in bounds.
  }

  void move() {
   x += vx;
   y += vy;

   // Rebound.
   vx = (x > width - d || x < 0 + d) ? -vx : vx;
   vy = (y > height - d || y < 0 + d) ? -vy : vy;

   facing = (vx < 0) ? -1 : 1;                                                  // Orient image w/travel direction.
   if (x <= 0 || x >= width) facing *= -1;                                      // Rebound orientation.
  }

  void scatter() {
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
      // animationArray[i].restrain();
    }
  }

}

/*  =========== Notes =========== /

Projector resolution = 1920 X 1080, throw ~= 132" X 73" @ ~110" distance.

*/