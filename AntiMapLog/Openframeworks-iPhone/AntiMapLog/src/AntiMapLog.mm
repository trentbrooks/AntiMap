
/**
 * AntiMap Log for iPhone/Openframeworks
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
 * Created in Openframeworks 007.
 * Addons: ofxTBiPhone, ofxTBDelaunay, MSAShape3D (https://github.com/memo/msalibs/tree/master/MSAShape3D)
 * Custom properties to add: Under TARGETS > AntiMapLog, under the 'Info' tab, where it says 'Custom IOS Target Properties'
 * you need to add 'Application supports iTunes file sharing' and set to 'YES'.
 *
 */

#include "AntiMapLog.h"


// MAIN
/* ------------------------------------------------------ */
// it's an ugly setup, but everything else should be pretty similar to android processing project.
void AntiMapLog::setup()
{	
    // DEFAULT properties (can't set from header, boooo!)
    // gps + compass
    currentLatitude = 0;
    currentLongitude = 0;
    currentLatitudeStr = "0.000000";
    currentLongitudeStr = "0.000000";
    direction = 0; // compass, not bearing.
    directionStr = "0";
    currentSpeed  = 0; 
    currentSpeedStr = "0.00";
    cumulativePhoneKms = 0.0f; // value from phone, kilometers
    cumulativePhoneKmsStr = "0.00";
    
    // file saving
    recording = false;
    fileIsValid = false;
    filePath = ""; // dynamic filename generated from date each save.
    
    // messages
    saveMessage = "";
    DATA_SUCCESS = "* CSV file saved to AntiMap Documents *";
    DATA_FAIL = "* No data to save. Waiting for GPS signal... *"; //"* No data to save *"
    DATA_SEARCH = "* Waiting for GPS signal... *"; //"* Searching for GPS signal... *"; // NEW
    URL_LINK = "WWW.THEANTIMAP.COM";
    line1Off = "Latitude / Longitude / Compass";
    line2Off = "Speed / Distance / Time";
    line1On = "Latitude / Longitude / Compass";
    line2On = "Speed / Distance / Time";
    lineTag = "Tag a location / ";
    
    // text input
    input = "";
    showInput = false;
    taggedLoc = 0;
    tagging = false;
    
    // timestamp
    startingTime = 0;//0.0; // whenever rec button pressed the startWatch resets to the millis().
    displayTime = "";
    time = 0;
    cmin = 0;
    csec = 0;

    // retina?
    retina = (ofGetWidth() > 480) ? true : false; 
    scaleMult = (retina) ? 2 : 1;
    
    // SETUP
    ofBackground(255,255,255);    
    ofSetFrameRate(30);
    ofSetCircleResolution(32);
    sw = ofGetWidth();
    sh = ofGetHeight();
    halfScreenX = (sw * .5);
    halfScreenY = (sh * .5);
    
    // initial message
    saveMessage = DATA_SEARCH; 
    
    // load images
    northSymbol.loadImage("n_iphone.png");
    logo.loadImage("logoAlt_iphone.png"); 
  
    // get the numbers right for retina & no retina, no magic numbers :(
    // could of done this other ways, but a single big if/else gives me finer control for retina and non retina modes.
    if(!retina)
    {
        // offsets
        txtOffsetY_line1 = 25;
        txtOffsetY_line2 = 45;
        txtOffsetY_line3 = 65;
        littleNWidth = 8;
        littleNOffsetX = 4;
        littleNOffsetY = 4;
        compassNorthOffset = 115;//140; // default
        destImgBtnX = sw - 70;
        keyboardPosX_low = 15;
        keyboardPosY_low = sh - 15;
        imgBtnPosX_low = destImgBtnX + 24;
        imgBtnPosY_low = sh - 48;
        keyboardPosX_high = 15;
        keyboardPosY_high = sh - 220;
        imgBtnPosX_high = destImgBtnX + 24;
        imgBtnPosY_high = sh - 254;
        keyboardWidth = destImgBtnX;
        keyboardHeight = 38;
        
        // load fonts 
        //ofTrueTypeFont::setGlobalDpi(72);
        //vagFont.loadFont("VAGRoundedStd-Light.otf", 10, true, true); // not open source
        vagFont.loadFont("MgOpenModataRegular.ttf", 10, true, true); //open source font
        //vagFont.setLetterSpacing(0.95);
        
        // resize images
        logo.resize(logo.width * .5, logo.height * .5);
        northSymbol.resize(northSymbol.width * .5, northSymbol.height * .5);
        
        // setup buttons
        imgBtn.setup(retina, imgBtnPosX_low, imgBtnPosY_low, "btnPlusA_iphone.png", "btnPlusB_iphone.png");
        recBtn.setup(retina, sw, sw/2 - 51, sh/2 + 10, "RECORD", "STOP");
        txtBtn.setup(retina, URL_LINK, int(sw/2) - 73, int(sh -  32), 146, 15);
        
        logoPosY = int(halfScreenY - logo.height + 1);
        
    }
    else
    {
        // offsets
        txtOffsetY_line1 = 50;
        txtOffsetY_line2 = 90;
        txtOffsetY_line3 = 130;
        littleNWidth = 16;
        littleNOffsetX = 7.5; // should be 8, but its not
        littleNOffsetY = 7.5;        
        compassNorthOffset = 230;
        destImgBtnX = sw - 140;
        keyboardPosX_low = 15;//30;
        keyboardPosY_low = (sh/2) - 15;//sh - 30; //keyboard positioning doesn't use retina widhts/heights???
        imgBtnPosX_low = destImgBtnX + 48;
        imgBtnPosY_low = sh - 96;
        keyboardPosX_high = 15;//30;
        keyboardPosY_high = (sh/2) - 220;//sh - 440;
        imgBtnPosX_high = destImgBtnX + 48;
        imgBtnPosY_high = sh - 508;
        keyboardWidth = (sw/2) -70;//destImgBtnX;
        keyboardHeight = 38;//76;
        
        // load fonts
        //vagFont.loadFont("VAGRoundedStd-Light.otf", 20, true, true); // not open source
        vagFont.loadFont("MgOpenModataRegular.ttf", 20, true, true); //open source font
        //vagFont.setLetterSpacing(0.93); //kerning weird on iphone
        
        // setup buttons
        imgBtn.setup(retina, imgBtnPosX_low, imgBtnPosY_low, "btnPlusA_iphone.png", "btnPlusB_iphone.png");
        recBtn.setup(retina, sw, sw/2 - 104, sh/2 + 20, "RECORD", "STOP");
        txtBtn.setup(retina, URL_LINK, int(sw/2) - 146, int(sh -  64), 292, 30);
                
        logoPosY = int(halfScreenY - logo.height + 2);
    }
    
    logoPosX = int(halfScreenX - (logo.width * .5));
    
    // fonts + listeners for buttons    
    recBtn.vagFont = vagFont;    
    txtBtn.vagFont = vagFont;
    txtBtn.halfScreenX = halfScreenX;
	ofAddListener(recBtn.onSliderButtonEvent,this,&AntiMapLog::onSliderButton); //int & i
    ofAddListener(txtBtn.onClickTextButtonEvent,this,&AntiMapLog::onClickTextButton); //int & i
    ofAddListener(imgBtn.onImageButtonEvent,this,&AntiMapLog::onImageButton); //int & i
    
    // setup sensors
    ofRegisterTouchEvents(this);
    ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
    coreLocation = new ofxiPhoneCoreLocationExtra();
	hasCompass = coreLocation->startHeading();
	hasGPS = coreLocation->startLocation();   
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
    ofxiPhoneDisableIdleTimer(); // disable phone sleep
    printf("\nPhone: %s\n", iPhoneGetDeviceRevision().c_str());
    
    // add bounding grid points and designated for triangley background effect
    addGridPointsRectangular();
    
    // add text field and hide
    keyboard = new ofxiPhoneKeyboardExtra(keyboardPosX_low, keyboardPosY_low, keyboardWidth, keyboardHeight);
	keyboard->setVisible(false);
	keyboard->setBgColor(255, 255, 255, 255); // retina weirdness if(retina) 
	keyboard->setFontColor(0,0,0, 255);
	keyboard->setFontSize(24);
    keyboard->disableAutoCorrection(); // disable auto type corrections, custom method added to ofxIphoneKeyboard.   
}


//--------------------------------------------------------------
void AntiMapLog::update()
{    
    // gets compass + gps data. different to android/processing which has a location listener.
    updateLocation();
    
    // save location + compass to text file
    logData();
    
    // check for touch interaction + update compass north (for triangulation).
    //updateTouchPoint(); // not needed
    updateNorthPoint();
    
    // update triangulation 
    triangle.triangulateExtra(points);  
    
    // move keyboard input when keyboard is open
    checkKeyboardStuff();
}


//--------------------------------------------------------------
void AntiMapLog::draw()
{
    ofBackground(255);
    ofEnableAlphaBlending();    
    
    // draw the triangles
    drawTrianglePaths();
    
    // update + draw the slider button
    recBtn.update(mouseX, mouseY);
    recBtn.display();    
    
    // draw the text info   
    drawLabelStats(); 
        
    // draw the logo
    ofSetColor(255, 255, 255, 255);
    logo.draw(logoPosX, logoPosY);//, LOGO_WIDTH, LOGO_HEIGHT);
    
    // draw the little N for compass
    drawCompass();
    
    ofDisableAlphaBlending();
	
}

//--------------------------------------------------------------
void AntiMapLog::touchDown(ofTouchEventArgs &touch){
    
	if( touch.id == 0 )
    {
        // tell all buttons mouse is pressed
        imgBtn.mouseIsDown = true;
        recBtn.mouseIsDown = true;
        txtBtn.mouseIsDown = true;
        touchPoint->x = touch.x;
        touchPoint->y = touch.y;
	}
}

//--------------------------------------------------------------
void AntiMapLog::touchMoved(ofTouchEventArgs &touch){
    
	if( touch.id == 0 )
    {        
        // update point position for triangulation under fingertip
        touchPoint->x = touch.x;
        touchPoint->y = touch.y;        
	}
}

//--------------------------------------------------------------
void AntiMapLog::touchUp(ofTouchEventArgs &touch){
    if( touch.id == 0 ){
        imgBtn.mouseIsDown = false;
        recBtn.mouseIsDown = false;
        txtBtn.mouseIsDown = false;
        
        // instead of adding/removing the touch point, just remove from sight: y=-100
        touchPoint->x = 0;
        touchPoint->y = -100;
    }
}

//--------------------------------------------------------------
void AntiMapLog::touchDoubleTap(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void AntiMapLog::touchCancelled(ofTouchEventArgs& args){
    
}

//--------------------------------------------------------------
void AntiMapLog::exit(){
    printf("\n\n APPLICATION EXITED... \n\n");
    // if 'recording' and user quits/closes app, export the data.
    if (recording)
    {
        exportData();
    }
}



// DATA LOGGING
/* ------------------------------------------------------ */
// when 'recording' create a file to save to.
void AntiMapLog::beginData()
{
    //coreLocation->resetCumulatedDistance();
    
    // display the text input field
    keyboard->openKeyboard();
    keyboard->setVisible(true);
    showInput = true;
    
    // make a file with filename ready for data
    fileIsValid = false;
    filePath = getTimeStamp() + ".csv";
    printf("Begin saving data: %s", filePath.c_str()); 
    output.open(ofxiPhoneGetDocumentsDirectory() + filePath.c_str(),ofFile::WriteOnly);
    
    // this needs to be written during validation in case 0.0s at the start. want to start timer from 0 millis as well.
    startingTime = ofGetElapsedTimeMillis();
    
    recording = true;    
    
}

void AntiMapLog::logData()
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
            
            // write the latitude, longitude, compass direction, speed, distance, duration, and location tag to the text file.
            // lat + long losing precision when conversion to string, forcing to 6 decimal places 
            output << currentLatitudeStr + "," + currentLongitudeStr + "," + directionStr + "," + currentSpeedStr + "," + cumulativePhoneKmsStr + "," + ofToString(time) + "," + input + "\n";
            
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

// write the file to PUBLIC DOCUMENTS or delete, then reset the vars
void AntiMapLog::exportData()
{
    if(output.exists() && !fileIsValid)
    {
        output.remove();
        printf("deleteing temp file- no data to save: ");
        saveMessage = DATA_FAIL;
    }
    else
    {
        output.close();
        printf("file saved");
        saveMessage = DATA_SUCCESS;
    }
  
    // reset
    currentLatitude = currentLongitude = 0;
    currentLatitudeStr = "0.000000";
    currentLongitudeStr = "0.000000";
    currentSpeed = 0;
    currentSpeedStr = "0.00"; 
    coreLocation->resetCumulatedDistance();
    cumulativePhoneKms = 0;
    cumulativePhoneKmsStr = "0.00";
    taggedLoc = 0;
    recording = false;
    showInput = false;
    keyboard->setVisible(false);
}

// if there are 0.0 values for any coords ignore - these were the defaults
bool AntiMapLog::checkForZeros(double lat, double lon)
{
    return (lat == 0 || lon == 0);
}

// add value when user 'tags a location'
void AntiMapLog::insertTag()
{
    input = keyboard->getText(); 
    ofStringReplace(input, ",", ""); //no commas allowed fool!
    keyboard->setText("");
    
    tagging = true;
}

// if user 'tags a location' we need to reset after adding.
void AntiMapLog::resetTags(bool updateCounter)
{
    // reset tagged location only if set to true from widget?
    if (tagging)
    {
        if (updateCounter) taggedLoc++;
        input = "";
        tagging = false;
    }
}

// timestamp help
void AntiMapLog::updateTime()
{
    time = ofGetElapsedTimeMillis() - startingTime; //(millis() - startingTime) / 1000;
    csec = int(time / 1000);
    cmin = int(csec / 60);
    csec = csec % 60;
}

string AntiMapLog::getTimeStamp()
{    
    string theYear = ofToString(ofGetYear()).substr(2); // just get the last 2 digits of the year (2011 > 11)
    return pad(ofGetDay()) + pad(ofGetMonth()) + theYear + "_" + pad(ofGetHours()) + pad(ofGetMinutes()) + "_" + pad(ofGetSeconds());
}



// TRIANGULATION + DRAWING
/* ------------------------------------------------------ */
void AntiMapLog::drawTrianglePaths()
{
    // draw all the background triangles
    triangle.drawTriangles();
    //triangle.drawTrianglesVertex();
}

// draw the text/labels + some buttons
void AntiMapLog::drawLabelStats(){
    
	ofSetColor(0, 0, 0);
    
    // display the time to user a bit more readable than just millis (note millis are logged to csv, not this)
    displayTime = pad(cmin) + ":" + pad(csec);
    
    // when in "record" mode display the stats and related text
    if (showInput)
    {
        // display VALUES for latitude, longitude, compass, speed, distance, time at the top.
        // can't get the degrees symbol????? removing for now
        // also ofToString rounds off after around 4 decimal places, so need to force to 6
        line1On = currentLatitudeStr + "\xB0 / " + currentLongitudeStr + "\xB0 / " + directionStr + "\xB0";
        line2On = currentSpeedStr + " kph / " + cumulativePhoneKmsStr + " kms / " + displayTime;
        
        vagFont.drawString(line1On, centerAlignX(line1On), txtOffsetY_line1);
        vagFont.drawString(line2On, centerAlignX(line2On), txtOffsetY_line2);
        
        // display text down bottom for tagging locations (POIS).
        lineTag = "Tag a location / " + ofToString(taggedLoc) + " added";    
        vagFont.drawString(lineTag, centerAlignX(lineTag), sh - txtOffsetY_line3);
        
        // little '+' button next to input field. only added because some phones don't have a 'done' button.
        imgBtn.update(mouseX, mouseY);
        imgBtn.display();
    }
    else
    {
        // display LABELS for latitude, longitude, compass, speed, distance, time at the top. 
        vagFont.drawString(line1Off, centerAlignX(line1Off), txtOffsetY_line1);
        vagFont.drawString(line2Off, centerAlignX(line2Off), txtOffsetY_line2);
        
        // display status message to user down the bottom
        vagFont.drawString(saveMessage, centerAlignX(saveMessage), sh - txtOffsetY_line2);
        
        // link button to antimap.com
        txtBtn.update(mouseX, mouseY);
        txtBtn.display();
    }
}

// thanks kyle mcdonald: http://forum.openframeworks.cc/index.php/topic,7728.0.html
// should be in ofUtils.h with T template and const T& value for first parameter, but keeping it here so there are less files to update.
string AntiMapLog::ofToStringAdaptive(double value, int precision){
	ostringstream out;
	out << setprecision(precision) << value;
	return out.str();
}


// visualise compass with little 'n' that points to the compass north.
void AntiMapLog::drawCompass()
{
    ofSetColor(255, 255, 255);
    ofCircle(northPoint->x,northPoint->y,littleNWidth);
    ofNoFill();
    ofSetColor(170, 170, 170);
    ofCircle(northPoint->x,northPoint->y,littleNWidth);
    northSymbol.draw(northPoint->x-littleNOffsetX, northPoint->y-littleNOffsetX);
    ofFill();
}

// translations to get screen coords for little "N" and triangulation
void AntiMapLog::updateNorthPoint()
{
    northPoint->x = compassNorthOffset * sin(ofDegToRad(direction)) + halfScreenX;
    northPoint->y = -compassNorthOffset * cos(ofDegToRad(direction)) + halfScreenY;
}

// screen coords for triangulation when surface screen is touched
void AntiMapLog::updateTouchPoint()
{
    // not required - use touchDown + touchUp instead
}

// for center aligning text properly on mobile (preserves antialiasing, rounds to nearest pixel)
int AntiMapLog::centerAlignX(string s)
{
    return int(halfScreenX - (vagFont.stringWidth(s) * .5));
}

// to generate the background we need to add some initial points for triangulation
void AntiMapLog::addGridPointsRectangular()
{
    float offset = 1;
    
    // corners
    points.push_back(new ofVec2f(-offset, -offset));
    points.push_back(new ofVec2f(sw+offset, -offset));
    points.push_back(new ofVec2f(sw+offset, sh+offset));
    points.push_back(new ofVec2f(-offset, sh+offset));
    
    
    int randPoints = 2;//5;
    int* topSpots = randomShuffled(1,sw - 1); // avoid points at the same position. weird triangulation diffs in OF.
    int* btmSpots = randomShuffled(1,sw - 1);
    int* leftSpots = randomShuffled(1,sh - 1);
    int* rightSpots = randomShuffled(1,sh - 1);
    for (int h = 0; h < randPoints; h++)
    {    
        points.push_back(new ofVec2f(topSpots[h], -offset)); // points up top
        points.push_back(new ofVec2f(btmSpots[h], sh+offset)); // points on bottom
        points.push_back(new ofVec2f(-offset, leftSpots[h])); // points on left
        points.push_back(new ofVec2f(sw+offset, rightSpots[h])); // points on right
    }
    
    delete []topSpots; topSpots = NULL;
    delete []btmSpots; btmSpots = NULL;
    delete []leftSpots; leftSpots = NULL;
    delete []rightSpots; rightSpots = NULL;
    
    // one in the middle
    points.push_back(new ofVec2f(sw * .5, sh * .5));
    
    //one for the north symbol in compass
    northPoint = new ofVec2f(halfScreenX, halfScreenY - compassNorthOffset);
    points.push_back(northPoint);
    
    // one for mouse/touch
    touchPoint = new ofVec2f(0,-100);
    points.push_back(touchPoint);
    
}

// same as random but without duplicates
int * AntiMapLog::randomShuffled(int min, int max)
{
    //vector<int> myvector;
    int range = max - min; // possibleValues;
    int *myArray = new int[range];
    //set some values for the range - ordered
    for (int h = min; h < max; h++)
    {
        myArray[h] = h;
    }
    
    random_shuffle(&myArray[0], &myArray[range-1]);
    return myArray;
}

// adds a leading zero
string AntiMapLog::pad(int value)
{
    if(value < 10) return "0" + ofToString(value);
    
    return ofToString(value);
}



// GUI EVENTS
/* ------------------------------------------------------ */
// move keyboard input when keyboard is open
void AntiMapLog::checkKeyboardStuff()
{
    if(showInput)
    {
        if(keyboard->isKeyboardShowing())
        {
            keyboard->setPosition(keyboardPosX_high, keyboardPosY_high);
            imgBtn.setPosition(imgBtnPosX_high, imgBtnPosY_high);
        }
        else
        {
            keyboard->setPosition(keyboardPosX_low, keyboardPosY_low);
            imgBtn.setPosition(imgBtnPosX_low, imgBtnPosY_low);
            
            //when keyboard is hidden, log the data and reset text if typed/return hit.
            if(keyboard->getLabelText().length() > 0) insertTag();
        }
    }
}

void AntiMapLog::onClickTextButton(int & i) // parameter irrelevant
{
    // not sure how to do this in OF, had to use striaght obj c?
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.theantimap.com" ];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

void AntiMapLog::onSliderButton(int & i) // parameter irrelevant
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

void AntiMapLog::onImageButton(int & i) // parameter irrelevant
{
    input = keyboard->getLabelText();
    
    //when keyboard is hidden, log the data and reset text if typed/return hit.
    if (input.length() > 0)
    {
        imgBtn.setPosition(imgBtnPosX_low, imgBtnPosY_low);
        keyboard->closeKeyboard(); // hide keyboard, custom method added to ofxIphoneKeyboard.
        insertTag();        
    }
    
}



// GPS/LOCATION/COMPASS 
/* ------------------------------------------------------ */
// gets compass + gps data. different to android/processing which has a location listener.
void AntiMapLog::updateLocation()
{
    // NOTE custom methods were added to the ofxiPhoneCoreLocation.
    if(hasGPS)
    {
		currentLatitude = coreLocation->getLatitude();
        currentLongitude = coreLocation->getLongitude();
        currentLatitudeStr = ofToString(currentLatitude,6);
        currentLongitudeStr = ofToString(currentLongitude,6);
                
        //printf("\n lat  %f  ,long   %f", currentLatitude, currentLongitude);
        if(initLocs)
        {
            // get cumulated meters and convert to kilometers
            cumulativePhoneKms = coreLocation->getCumulatedDistance() * 0.001; 
            cumulativePhoneKmsStr = ofToString(cumulativePhoneKms,2);
        }
        else
        {
            if(coreLocation->hasLocationRecorded()) // custom method added to ofxiPhoneCoreLocation
            {
                // if location coords have been found - remove the status message (runs once only)
                initLocs = true;
                saveMessage = "";  
            }
        }
        
        // convert speed to km
        float cs = (float)coreLocation->getSpeed() * 3.6;
        currentSpeed = (cs < 0) ? 0 : cs; // make sure speed is never below 0
        currentSpeedStr = ofToString(currentSpeed,2);
        
    }
    if(hasCompass) {
        direction = int(360 - coreLocation->getTrueHeading());//int(-coreLocation->getTrueHeading()) + 360; //getMagneticHeading()); //getTrueHeading());//coreLocation->getTrueHeading();
        directionStr = ofToString(direction);
    }
}


