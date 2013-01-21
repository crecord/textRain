//I'm trying a new commit
//mod
//I'm adding another useless comment
import processing.video.*;
Capture video;
PImage backgroundImage;
int thresh = 100;
PFont f;
String message = "Each character is written individually.";
int len = message.length();
int[] xpos = new int[len];
ArrayList fallObj;
Letter myLetter;
int Start;

void setup() {
  size(640, 360);
  video = new Capture(this, width, height, 30);
  video.start();
  backgroundImage = createImage(video.width, video.height, RGB);
  int Start = millis();
  f = createFont("Arial", 20, true);
  background(255);
  fill(0);
  textFont(f);         

  // The first character is at pixel 10.
  int x = 10; 
  for (int i = 0; i < message.length(); i++) {
    xpos[i] = x;
    x += textWidth(message.charAt(i));
  }
  fallObj = new ArrayList();
}

void draw() { 
  if (video.available()) {
    video.read();
  }
  loadPixels ();
  video.loadPixels();
  backgroundImage.loadPixels();

  for (int x=0; x< video.width; x++) {
    for (int y=0; y<video.height; y++) { 

      int loc = x + y*video.width;
      //float currentPix = video.pixels[loc];
      float bright = brightness(video.pixels[loc]);
      if (bright < thresh ) {
        pixels[loc] = color(0);
      }
      else {
        pixels[loc] = color(255);
      }
    }
  }
  updatePixels();
  if ((millis() - Start)%5 == 0) {
    int index = int(random (len));
    char newC = message.charAt(index);
    int currentX = xpos[index];  
    myLetter = new Letter(newC, currentX);
    fallObj.add(myLetter);
  }

  for (int i = fallObj.size()-1; i >= 0; i--) {
    Letter current = (Letter) fallObj.get(i);
    int state = current.check();
    if (state == 1) {
      fallObj.remove(i);
      break;
    }
    else{
      current.update();
    }
  }
}

class Letter {
  // function that keeps itself falling
  int yPos;
  char currentLetter;
  int xPos;
  Letter ( char ch, int X) {
    yPos = 0;
    xPos= X;
    currentLetter = ch;
  }

  void update () {
    // check if is in the black or the white and move accordingly
    text(currentLetter, xPos, yPos-5);
    int locImage = xPos + yPos*video.width;
    int checkB = int(brightness(video.pixels[locImage]));
    if ( checkB > thresh) {
      yPos++;
    }
    else if (yPos > 0 && checkB < thresh) {
      yPos--;
    }
    
    
  }
  int check() {
    int locImage = xPos + yPos*video.width;
    if ((yPos > height) || (locImage >= video.pixels.length)){
      return 1;
    }
    else {
      return 0;
    }
    // remove the object if it has touched the bottom
  }
}

