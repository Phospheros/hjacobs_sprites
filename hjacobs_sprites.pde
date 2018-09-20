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

// ================================== //

void setup() {
  size(1000, 1000, P3D);

  java.io.File spritesFolder = new java.io.File(dataPath("Sprites"));  // data/Sprites
  String[] files = spritesFolder.list();  // All files (including invisibles).
  imageList = new StringList();  // Images array.
  figuresList = new StringList();  // Figures list ref. (but not frames).
  figuresIndex = new IntList();
  
  sprites = new PImage[files.length];

  int appendCount = 0;  // Used to access image array[], which may be different from files[i].
  for (int i = 0; i < spritesFolder.list().length; i++) {  // All files...
    if ( files[i].toLowerCase().endsWith(".png")) {        // ... only images.
      imageList.append(files[i]);                          // Build image array.      
      sprites[i] = loadImage("Sprites/" + imageList.get(appendCount));
      //println(imageList.get(appendCount));               // Debug.
      appendCount++ ;
    }
  }    

  figuresList = imageList.copy();                          // Build list of figures  
  String substring;                                        // by cutting suffix info, and
  String trimmed;                                          // leaving only prefix,

  for(int i = 0; i < figuresList.size(); i++) {
    substring = figuresList.get(i).substring(8, 20);
    //println(substring);
    trimmed = figuresList.get(i).replace(substring, "");
    figuresList.set(i, trimmed);                           // resulting here. Then, 
    //println(figuresList.get(i));
  }
  
  for(int i = 0; i < figuresList.size(); i++ ) {
    figuresIndex.appendUnique(figuresList.index(figuresList.get(i)));  // Unique figures index.
  }

  String[] figuresUnique = figuresList.getUnique();    // create array exclusive of duplicates.
  
      
      
      
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
  //println(figuresList);  
  //println(figuresUnique);  
  //println(figuresIndex);
}

// ================================== //

void draw() {
  background(255);  
  
  //image(sprites[count], width/2, height/2);
  //count = count % (imageList.size());  
  //count++ ;
  
  for(int i = 0; i < 6; i++) {
    animationArray[i].show();
    //println(animationArray[i].name);
    //println(animationArray[i].index);
  }
 
  //exit();
}

/* ======= Class ======= */

class Animation {
  String name;
  int index;
  float x, y;
  int count = 0;
  //int d = 10;
  //float vx = random(-.5, .5);
  //float vy = vx * random(-2, 2);

  Animation(String name, int index, float x, float y) {
    this.name = name;
    this.index = index;
    this.x = x;
    this.y = y;
  }

  void show() {
    
    count = (imageList.get(index + count).contains(name)) ? count : 0;
    image(sprites[index + count + 1], x, y);  // sprites, imageList off by 1.
    //println(name + "  " + index + "  " + count + "  " + imageList.get(index + count));    
    //println(index + count + 1);
    count++ ;
    if(index + count + 1 >= sprites.length) count = -1;  // Keep sprites in bounds. 
    
    
    //count = 1; println("/n");
  }
  
  //void reInit() {
  //  vx = random(-.5, .5);
  //  vy = vx * random(-2, 2);
  //}

  //void restrain() {
  //  // Multiple approaches are needed for boundary and out-of-bounds situations.
  //  if (x !=x || y != y) reInit();  // Just in case NaN results (It's happened in testing).
  //  x = constrain(x, 0, width);
  //  y = constrain(y, 0, height);
  //  // Add a little padding for wiggle room.
  //  x = (x <= 0) ? 2 * d : (x >= width) ? width - (2 * d) : x;
  //  y = (y <= 0) ? 2 * d : (y >=height) ? height - (2 * d) : y;
  //}
  
  //void move() {
  //  x += vx;
  //  y += vy;
  //  // Rebound.
  //  vx = (x > width - d || x < 0 + d) ? -vx : vx;
  //  vy = (y > height - d || y < 0 + d) ? -vy : vy;  
  //}
  
}