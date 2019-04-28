//webcam stuff
import processing.video.*;
Capture video;

// colors being tracked
color trackColorRed; 
color trackColorGreen;
color trackColorBlue;  
color d,r1,g1,b1,r2,g2,b2;
//arraylist for draw points
ArrayList<PVector> points = new ArrayList();

// display stuff
void setup() {
  stroke(25);
  size(displayWidth,displayHeight);
  video = new Capture(this, width, height);
  video.start();

  
  
  // colors we're looking for: red, green, and blue
  
  // red tracking 
  trackColorRed = color(255, 0, 0);
  // green tracking 
   trackColorGreen = color(0, 255, 0);
  // blue tracking 
   trackColorBlue = color(0, 0, 255);
}

void captureEvent(Capture video) {
  video.read();
}

// sorting through pixels to find colors
void draw() {
  // background(0);
  video.loadPixels();
  image(video, 0, 0);

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat. 
  float worldRecord = 500; 

  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;
    
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColorRed);
      float g2 = green(trackColorGreen);
      float b2 = blue(trackColorBlue);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
        trackDraw(x,y);
      
        
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 10){ 
 
    // Draw a circle at the tracked pixel
    if(d == b1 || d== b2) {
    fill(trackColorBlue);
    strokeWeight(1.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
  }
  if (d == g1 || d== g2){
    fill(trackColorGreen);
    strokeWeight(1.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
  }
  if (d == r1|| d== r2){
    fill(trackColorRed);
    strokeWeight(1.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
  }}
  
}
  
void trackDraw(int x,int y){
    points.add(new PVector(x, y));
  
  // Limit it to the last 100 points.
  while( points.size() > 100 ){
    points.remove(0);
    points.remove(1);
  }
  // Draw a line between all the points.
  for(int i = 0; i < points.size()-1; i++){
    line(points.get(i).x,points.get(i).y,points.get(i+1).x,points.get(i+1).y);
  }
}


void mousePressed() {
  if( mousePressed ){
    
  // Save color where the mouse is clicked in trackColor variable
 int loc = mouseX + mouseY*video.width;
  trackColorRed = video.pixels[loc];
  // Use the positon of the mouse (if the mouse is clicked) to spoof a detected point.
 
}
}
