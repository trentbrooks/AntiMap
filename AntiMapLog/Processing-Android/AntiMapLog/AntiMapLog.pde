
/**
 * AntiMap Log for Android/Processing
 * Copyright (c) 2012 Trent Brooks, http://www.trentbrooks.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ------------------------------------------------------ 
 *
 * ABOUT
 * AntiMap Log is a smart phone utility application for ‘recording’ your own data.
 * Created in Processing 1.5.
 * Requires: Android SDK (http://wiki.processing.org/w/Android).
 * Libraries: apwidgets.jar (http://code.google.com/p/apwidgets/) & triangulate.jar (http://wiki.processing.org/w/Triangulation) to be added to the 'code' folder.
 * Permissions: ACCESS_FINE_LOCATION, WRITE_EXTERNAL_STORAGE
 *
 */


// IMPORTS
/* ------------------------------------------------------ */
import org.processing.wiki.triangulate.*;
import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;
import android.view.*; //?
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.location.LocationListener;
import android.location.GpsStatus.Listener;
import android.os.Bundle;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.view.View;


// PROPERTIES
/* ------------------------------------------------------ */
// display
SliderButton recBtn;
TextButton txtBtn;
ImageButton imgBtn;
PFont vagFont;
PImage logo;
PImage northSymbol;
PImage defaultImg;
int halfScreenX, halfScreenY; 
int sw, sh; 
int logoPosX, logoPosY; 
float halfLogoY;
//int fontSize = 20; // default
int compassNorthOffset = 190; // default
String optLineBreak = "";
int smallScreenYOffset1 = 0; 
int smallScreenYOffset2 = 0;

// triangulation
ArrayList triangles = new ArrayList();
ArrayList points = new ArrayList();
PVector northPoint;
PVector touchPoint;
boolean allowTouch = false;

// sensors
CompassManager compass;
LocationManager locationManager;
MyLocationListener locationListener;

// GPS and compass data
double currentLatitude = 0;
double currentLongitude = 0;
String currentLatitudeStr = "0.000000";
String currentLongitudeStr = "0.000000";
int direction = 0; // compass, not bearing.
float currentSpeed  = 0; 
String currentSpeedStr = "0.00"; 
float cumulativeMs = 0.0f; // meters
float cumulativePhoneKms = 0.0f; // value from phone, kilometers
String cumulativePhoneKmsStr = "0.00";
float currentAccuracy = 0; 
String currentProvider = "";

// file saving
boolean recording = false;
String savePath = "//sdcard//AntiMap//";
boolean fileIsValid = false;
String filePath; // dynamic filename generated from date each save.
PrintWriter output;

// messages
String saveMessage = "";
String DATA_SUCCESS = "* CSV file saved to sdcard/AntiMap *";
String DATA_FAIL = "* No data to save. Waiting for GPS signal... *"; //"* No data to save *"
String DATA_SEARCH = "* Waiting for GPS signal... *"; //"* Searching for GPS signal... *"; // NEW
String URL_LINK = "WWW.THEANTIMAP.COM";
String line1Off = "Latitude / Longitude / Compass";
String line2Off = "Speed / Distance / Time";
String line1On = "Latitude / Longitude / Compass";
String line2On = "Speed / Distance / Time";
String lineTag = "Tag a location / ";

// text input (uses apwidgets component)
PWidgetContainer widgetContainer; 
PEditText tf;
String input = "";
boolean showInput = false;
int taggedLoc = 0;
boolean tagging = false;

// timestamp
int startingTime = 0;//0.0; // whenever rec button pressed the startWatch resets to the millis().
String displayTime = "";
int time = 0;
int cmin = 0;
int csec = 0;


// MAIN
/* ------------------------------------------------------ */
void setup() 
{
  size(screenWidth, screenHeight, A3D);
  hint(DISABLE_OPENGL_2X_SMOOTH);
  orientation(PORTRAIT);
  smooth();
  frameRate(30);
  background(255);
  sw = screenWidth;
  sh = screenHeight;
  halfScreenX = int(sw * .5);
  halfScreenY = int(sh * .5);
  println("screen width: " + sw + " / screen height: " + sh);

  //get the default image up and scale to screen size.
  defaultImg = loadImage("Default2.png");

  float scaleHeightRatio = (float) sh / defaultImg.height;
  float newImgWidth = defaultImg.width * scaleHeightRatio;
  float newImgHeight = defaultImg.height * scaleHeightRatio;
  float xImgOffset = (sw * .5) - (newImgWidth * .5); // position image in the middle
  image(defaultImg, xImgOffset, 0, newImgWidth, newImgHeight); // scale image to height then, width to fill 

  /*
  float scaleHeightRatio = (float) defaultImg.height / defaultImg.width;
   float scaleWidthRatio = (float) defaultImg.width / defaultImg.height;
   float stageWidthRatio  = (float) sh / sw;
   println("width: " + scaleHeightRatio);
   println("height: " + scaleHeightRatio);
   println("stage: " + stageWidthRatio);
   // if you flip the operator below to >= then it will change from a 'letterbox mode' to a 'crop to fit' mode
   if (scaleWidthRatio >= stageWidthRatio)
   {
   println("resizeA: " + sw + ", " + int(sw * scaleWidthRatio));
   defaultImg.resize(sw, int(sw * scaleWidthRatio));
   }
   else
   {
   println("resizeB: " + int(sh * scaleHeightRatio) + ", " + sh);
   defaultImg.resize(int(sh * scaleHeightRatio), sh);
   }
   // center image and draw
   image(defaultImg, sw * .5 - defaultImg.width * .5, sh * .5 - defaultImg.height * .5); // scale image to height then, width to fill 
   */
  // if small screen size change offsets
  if (sw <= 320) 
  {
    compassNorthOffset = 150;
    println("** small screen detected **");
    smallScreenYOffset1 = 30; // bump line up
    smallScreenYOffset2 = 1000; // hidden
  }

  // initial message
  saveMessage = DATA_SEARCH;  

  // setup buttons
  int destImgBtnX = sw - 101;
  imgBtn = new ImageButton(destImgBtnX + 24, sh-89, "btnPlusA.png", "btnPlusB.png");
  recBtn = new SliderButton(halfScreenX - 87, halfScreenY + 15, "RECORD", "STOP");
  txtBtn = new TextButton(URL_LINK, int(halfScreenX) - 110, int(sh -  32)-15, 220, 25);

  // load fonts  
  //vagFont = createFont("VAGRoundedStd-Light.otf", 20, true); // not open source
  vagFont = createFont("MgOpenModataRegular.ttf", 20, true); // open source font
  textFont(vagFont, 20);

  // load images
  northSymbol = loadImage("n.png");
  logo = loadImage("logoAlt.png"); 
  logoPosX = halfScreenX - (logo.width/2);
  halfLogoY = 0;//logo.height;
  logoPosY = halfScreenY - logo.height + 1;

  // setup sensors
  compass = new CompassManager(this);

  // add bounding grid points and designated for triangley background effect
  addGridPointsRectangular();

  // add text field and hide
  widgetContainer = new PWidgetContainer(this); //create new container for widgets
  tf = new PEditText(20, sh-100, destImgBtnX - 5, 80); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(tf); //place textField in container
  tf.setInputType(InputType.TYPE_CLASS_TEXT);
  tf.setImeOptions(EditorInfo.IME_ACTION_DONE); //Enables a Done button
  tf.setCloseImeOnDone(true); //close the IME when done is pressed
  widgetContainer.hide();
}

void draw() 
{
  background(255);

  // save location + compass to text file
  logData();

  // check for touch interaction + update compass north (for triangulation).
  updateTouchPoint();
  updateNorthPoint();

  // update triangulation  
  triangles = Triangulate.triangulate(points);

  // draw the triangles
  drawTrianglePaths();

  // update + draw the slider button
  recBtn.update();
  recBtn.display();

  // draw the text info
  drawLabelStats();  

  // draw the logo
  image(logo, logoPosX, logoPosY);

  // draw the little N for compass
  drawCompass();
}

void onCreate(Bundle bundle) 
{
  super.onCreate(bundle);

  // fix so screen doesn't go to sleep when app is active
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void onPause() 
{
  println("paused");
  super.onPause();
}

void onResume() 
{
  println("resume");
  super.onResume();

  // Build Listener
  locationListener = new MyLocationListener();

  // Acquire a reference to the system Location Manager
  locationManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);

  // Register the listener with the Location Manager to receive location updates
  locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);
}

void stop() {
  println("stopped");  

  // if 'recording' and user quits/closes app, export the data.
  if (recording)
  {
    exportData();
  }

  super.stop();
}


// DATA LOGGING
/* ------------------------------------------------------ */
// when 'recording' create a file to save to.
void beginData()
{  
  // display the text input field
  widgetContainer.show();
  showInput = true;

  // make a file with filename ready for data
  fileIsValid = false;
  filePath = savePath + getTimeStamp() + ".csv";
  println("Begin saving data: " + filePath);
  output = createWriter(filePath);

  // this needs to be written during validation in case 0.0s at the start. want to start timer from 0 millis as well.
  startingTime = millis(); 

  recording = true;
}

// writing to csv file at 30fps
void logData() 
{
  if (recording)
  {
    // run the timer updates
    updateTime();

    // make sure there are no zeros in the coordinates, otherwise ignore
    if (!checkForZeros(currentLatitude, currentLongitude))
    {
      // file is valid only if data is written (eg. no 0.0 coords). only runs once per record set.
      if (!fileIsValid) 
      {        
        fileIsValid = true;
      }

      // write the latitude, longitude, compass direction, duration, and location tag to the text file.
      output.println(currentLatitudeStr +","+currentLongitudeStr + "," + direction + "," + currentSpeedStr + "," + cumulativePhoneKmsStr + "," + time + "," + input); //cumulativePhoneKms

      // reset the tags, pass true - notify is writing to a file
      resetTags(true);
    }
    else
    {
      // reset the tags, pass false - notify is NOT writing to a file
      resetTags(false);
    }
  }
}

// write the file to SD card or delete, then reset the vars
void exportData()
{
  File f = new File(filePath);
  if (f.exists() && !fileIsValid) 
  {
    boolean deleted = f.delete();
    println("deleteing temp file- no data to save: " + deleted);
    saveMessage = DATA_FAIL;
  }
  else
  {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    output = null;
    println("file saved");
    saveMessage = DATA_SUCCESS;
  }

  // reset
  currentLatitude = currentLongitude = 0;
  currentLatitudeStr = "0.000000";
  currentLongitudeStr = "0.000000";
  currentSpeed = 0;
  currentSpeedStr = "0.00"; 
  cumulativeMs = 0;
  cumulativePhoneKms = 0;
  cumulativePhoneKmsStr = "0.00";
  taggedLoc = 0;
  recording = false;
  showInput = false;
  widgetContainer.hide();
}

// if there are 0.0 values for any coords ignore - these were the defaults
boolean checkForZeros(double lat, double lon)
{
  return (lat == 0 || lon == 0);
}

// add value when user 'tags a location'
void insertTag()
{
  input = replaceCommasWith(tf.getText(), ""); //no commas allowed fool!
  println("adding input " + input);
  tf.setText("");

  tagging = true;
}

// if user 'tags a location' we need to reset after adding.
void resetTags(boolean updateCounter)
{
  // reset tagged location only if set to true from widget?
  if (tagging)
  {
    if (updateCounter) taggedLoc++;
    input = "";
    tagging = false;
  }
}

// failsafe for user input to avoid commas (messes the csv file)
String replaceCommasWith(String v, String with)
{
  return v.replaceAll("\\,", with);
}

// timestamp help
void updateTime()
{
  time = millis() - startingTime; //(millis() - startingTime) / 1000;
  csec = int(time / 1000);
  cmin = int(csec / 60);
  csec = csec % 60;
}

// for creating the filename in format DDMMYY_HHMM_SS, eg. 251211_1200_30
String getTimeStamp()
{
  String theYear = nf(year(), 4).substring(2); // just get the last 2 digits of the year (2011 > 11)
  return "" + nf(day(), 2) + nf(month(), 2) + theYear + "_" + nf(hour(), 2) + nf(minute(), 2) + "_" + nf(second(), 2);
}


// TRIANGULATION + DRAWING
/* ------------------------------------------------------ */
void drawTrianglePaths()
{
  // draw all the background triangles
  strokeWeight(1.0f); // won't draw smaller than a 1, booooo!
  stroke(170);
  beginShape(TRIANGLES);
  for (int i = 0; i < triangles.size(); i++) {
    Triangle t = (Triangle)triangles.get(i);
    fill(200); //(215); //230
    vertex(t.p1.x, t.p1.y);
    fill(255);
    vertex(t.p2.x, t.p2.y);
    vertex(t.p3.x, t.p3.y);
  }
  endShape();
}

// draw the text/labels + some buttons
void drawLabelStats()
{
  fill(0);

  // display the time to user a bit more readable than just millis (note millis are logged to csv, not this)
  displayTime = nf(cmin, 2) + ":" + nf(csec, 2);

  // when in "record" mode display the stats and related text
  if (showInput)
  {
    // display VALUES for latitude, longitude, compass, speed, distance, time at the top.
    line1On = currentLatitudeStr + "° / " + currentLongitudeStr + "° / " + direction + "°";
    line2On = currentSpeedStr + " kph / " + cumulativePhoneKmsStr + " kms / " + displayTime;
    text(line1On, alignTextX(line1On, int(halfScreenX)), 38);
    text(line2On, alignTextX(line2On, int(halfScreenX)), 68);

    // display text down bottom for tagging locations (POIS).
    lineTag = "Tag a location / " + taggedLoc + " added";    
    text(lineTag, alignTextX(lineTag, int(halfScreenX)), int(sh -  117));

    // little '+' button next to input field. only added because some phones don't have a 'done' button.
    imgBtn.update();
    imgBtn.display();
  }
  else
  {
    // display LABELS for latitude, longitude, compass, speed, distance, time at the top. 
    text(line1Off, alignTextX(line1Off, int(halfScreenX)), 38);
    text(line2Off, alignTextX(line2Off, int(halfScreenX)), 68);

    // display status message to user down the bottom
    text(saveMessage, alignTextX(saveMessage, int(halfScreenX)), int(sh -  66));    

    // link button to antimap.com
    txtBtn.update();
    txtBtn.display();
  }
}

// visualise compass with little 'n' that points to the compass north.
void drawCompass()
{
  fill(255);
  stroke(0, 127);
  ellipse(northPoint.x, northPoint.y, 24, 24);
  fill(0);
  image(northSymbol, northPoint.x - 12, northPoint.y - 12);
}

// translations to get screen coords for little "N" and triangulation
void updateNorthPoint()
{
  // quick translate & rotate fix
  //pushMatrix();
  //translate(halfScreenX, halfScreenY);
  //rotate(radians(direction));

  //adjust the northPoint coordinates - moves the triangle point as well. variables to hold the positions to be used by the little N for compass
  northPoint.x = compassNorthOffset * sin(radians(direction)) + halfScreenX; //modelX(0, -compassNorthOffset, 0);
  northPoint.y = -compassNorthOffset * cos(radians(direction)) + halfScreenY; //modelY(0, -compassNorthOffset, 0);
  //popMatrix();
}

// screen coords for triangulation when surface screen is touched
void updateTouchPoint()
{
  if (mousePressed) 
  {
    touchPoint.x = mouseX;
    touchPoint.y = mouseY;
    if (!allowTouch)
    {
      //add the touch point vector the points triangle list
      allowTouch = true;
      points.add(touchPoint);
    }
  }
  else
  {
    if (allowTouch)
    {
      // delete the touch point vector from the points triangle list
      int deleteTouchPointId = points.indexOf(touchPoint);
      points.remove(deleteTouchPointId);
      allowTouch = false;
    }
  }
}

// for center aligning text properly on mobile (preserves antialiasing, rounds to nearest pixel)
int alignTextX(String someText, int destX)
{
  return int(-textWidth(someText) * .5 + destX);
}

// to generate the background we need to add some initial points for triangulation
void addGridPointsRectangular()
{
  float offset = 1;

  // add points in the corners
  float radius = sw/1.33;
  points.add(new PVector(-offset, -offset));
  points.add(new PVector(sw+offset, -offset));
  points.add(new PVector(sw+offset, sh+offset));
  points.add(new PVector(-offset, sh+offset));

  // random points per side
  int randPoints = 2;//5;
  for (int h = 0; h < randPoints; h++)
  {    
    points.add(new PVector(random(-offset, sw+offset), -offset)); // points up top
    points.add(new PVector(random(-offset, sw+offset), sh+offset)); // points on bottom
    points.add(new PVector(-offset, random(-offset, sh+offset))); // points on left
    points.add(new PVector(sw+offset, random(-offset, sh+offset))); // points on right
  }

  // one in the middle
  points.add(new PVector(screenWidth/2, screenHeight/2));

  // one for the north symbol in compass
  northPoint = new PVector(screenWidth/2, screenHeight/2 - compassNorthOffset);
  points.add(northPoint);

  // one for user touch
  touchPoint = new PVector();
  //points.add(touchPoint);
}


// GUI EVENTS
/* ------------------------------------------------------ */
// triggered when the 'done' key is pressed (apwidget)
void onClickWidget(PWidget widget) 
{  
  if (widget == tf) 
  {
    input = tf.getText();
    if (input.length() > 0) insertTag();
  }
}

// triggered when slider button action complete
void onSliderButton()
{
  if (!recording)
  {
    // start recording first touch
    beginData();
  }
  else
  {
    // stop recording second touch and export file and quit
    exportData();
  }
}

// triggered when the little '+' image button is pressed (same as the done key above)
void onClickImageButton()
{
  input = tf.getText();
  if (input.length() > 0) 
  {
    insertTag();

    // need to force hide the keyboard
    InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
    imm.hideSoftInputFromWindow(((EditText)tf.getView()).getWindowToken(), 0);
  }
}

// triggered when push text button action complete
void onClickTextButton()
{
  println("url button pressed");
  link("http://www.theantimap.com", "_new");
}


// GPS LOCATION LISTENER EVENTS
/* ------------------------------------------------------ */
// Define a listener that responds to location updates. used for latitude, longitude, distance + speed.
class MyLocationListener implements LocationListener 
{
  Location prevLocation;
  boolean initLocs = false;

  void onLocationChanged(Location location) 
  {
    // Called when a new location is found by the network location provider.
    currentLatitude  = location.getLatitude();
    currentLongitude = location.getLongitude();

    // need to format to 6 decimal places (doubles add extra digits, floats get shit after 4-5 decimals)
    currentLatitudeStr = nf((float)currentLatitude, 1, 6);
    currentLongitudeStr = nf((float)currentLongitude, 1, 6);

    //println("1) " + (float)currentLatitude);
    //println("2) " + location.getLatitude());
    // don't need em?
    ///currentAccuracy  = (float)location.getAccuracy();
    //currentProvider  = location.getProvider();

    if (initLocs)
    {
      // can use this instead of harvesine?
      float ms = (float)location.distanceTo(prevLocation);
      cumulativeMs += ms;

      // convert meters to kilometers
      cumulativePhoneKms = cumulativeMs * 0.001;//nf(cumulativeMs * 1000, 1, 2);

      // format to 2 decimal places
      cumulativePhoneKmsStr = nf(cumulativePhoneKms, 1, 2);
    }
    else
    {
      // if location coords have been found - remove the status message (runs once only)
      initLocs = true;
      saveMessage = "";
    }

    // if we have speed on the phone, log it and convert to km
    if (location.hasSpeed()) 
    {
      float cs = (float)location.getSpeed() * 3.6;
      currentSpeed = (cs < 0) ? 0 : cs;

      // format to 2 decimal places
      currentSpeedStr = nf(currentSpeed, 1, 2);
    }

    prevLocation = location;
  }

  void onProviderDisabled (String provider) { 
    //currentProvider = "";
  }

  void onProviderEnabled (String provider) { 
    //currentProvider = provider;
  }

  void onStatusChanged (String provider, int status, Bundle extras) {
    // Nothing yet...
  }
}


// COMPASS EVENTS
/* ------------------------------------------------------ */
void directionEvent(float newDirection) 
{
  // translate to compass position
  direction = int(360 - newDirection);
}

