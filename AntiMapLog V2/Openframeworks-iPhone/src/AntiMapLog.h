
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
 * Addons: ofxTBiPhone, ofxDelaunayPlus, MSAShape3D (https://github.com/memo/msalibs/tree/master/MSAShape3D)
 * Custom properties to add: Under TARGETS > AntiMapLog, under the 'Info' tab, where it says 'Custom IOS Target Properties'
 * you need to add 'Application supports iTunes file sharing' and set to 'YES'.
 *
 */

#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "DumbGUI.h"
#include "ofxiPhoneCoreLocationExtra.h"
#include "ofxiPhoneKeyboardExtra.h"
#include "ofxDelaunayExtra.h"
#include "ofxTouchGUI.h"
#include "ofxCoreMotion.h"

class AntiMapLog : public ofxiPhoneApp {
	
public:
    
    // DEFAULTS
    /* ------------------------------------------------------ */ 
	void setup();
	void update();
	void draw();
    void exit();
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	void touchCancelled(ofTouchEventArgs &touch);
    
    // SETTINGS SCREEN
    /* ------------------------------------------------------ */ 
    void setupGUI();
    ofxTouchGUI settings;
    bool recordGPS;
    bool recordCompass;
    bool recordSpeed;
    bool recordDistance;
    bool recordTime;
    bool recordGyroscope;
    bool recordAccelerometer;
    int recordRate;
    
    // PROPERTIES
    /* ------------------------------------------------------ */    
    // display
    SliderButton recBtn;
    TextButton txtBtn;
    ImageButton imgBtn;
    ofTrueTypeFont vagFont;
    ofImage logo;
    ofImage northSymbol;
    float halfScreenX, halfScreenY; 
    int sw, sh; 
    int logoPosX, logoPosY; 
    int compassNorthOffset; // default

    // display offsets (avoiding magic numbers for iphone retina)
    int txtOffsetY_line1;
    int txtOffsetY_line2;
    int txtOffsetY_line3;
    int littleNWidth;
    float littleNOffsetX;
    float littleNOffsetY;
    int destImgBtnX;
    int keyboardPosX_low;
    int keyboardPosY_low;
    int imgBtnPosX_low;
    int imgBtnPosY_low;
    int keyboardPosX_high;
    int keyboardPosY_high;
    int imgBtnPosX_high;
    int imgBtnPosY_high;
    int keyboardWidth;
    int keyboardHeight;
    
    // triangulation
    int* randomShuffled(int min, int max); // creates seeded random values from a range
    ofxDelaunayExtra triangle;
    vector<ofVec2f*> points;
    ofVec2f* touchPoint;
    ofVec2f* northPoint;
    
    //retina
    bool retina;
    float scaleMult;       
    
    // sensors
    ofxCoreMotion* coreMotion;
    ofxiPhoneCoreLocationExtra * coreLocation;	
    float heading;	
    bool hasCompass;
    bool hasGPS;    
    
    // GPS and compass data. string values were added so not to duplicate on ofToString conversions
    double currentLatitude;
    double currentLongitude;
    string currentLatitudeStr;
    string currentLongitudeStr;
    int direction; // compass, not bearing.
    string directionStr; 
    float currentSpeed; 
    string currentSpeedStr;
    float cumulativePhoneKms; // value from phone converted to kilometers
    string cumulativePhoneKmsStr;
    bool initLocs;
    
    // core motion data
    string currentAccelerometer; // x,y,z
    string currentGyroscope; // x,y,z
    string currentMagnetometer; // x,y,z
    string currentAttitude; // roll,pitch,yaw
    
    // file saving		
    ofFile output;
    string filePath; // dynamic filename generated from date each save.
    bool recording;
    bool fileIsValid;
    
    // messages
    string saveMessage;
    string DATA_SUCCESS;
    string DATA_FAIL; //"* No data to save *"
    string DATA_SEARCH; //"* Searching for GPS signal... *"; // NEW
    string URL_LINK;
    string line1Off;
    string line2Off;
    string line3Off;
    string line1On;
    string line2On;
    string line3On;
    string lineTag;
    
    // text input
    ofxiPhoneKeyboardExtra * keyboard;
    string input;
    bool showInput;
    int taggedLoc;
    bool tagging;
    
    // timestamp
    int startingTime;//0.0; // whenever rec button pressed the startWatch resets to the millis().
    string displayTime;
    int time;
    int cmin;
    int csec;
    
    
    // METHODS
    /* ------------------------------------------------------ */ 
    // data logging
    void logData();
    void beginData();
    void exportData();
    bool checkForZeros(double lat, double lon);
    void insertTag();
    void resetTags(bool updateCounter);
    string getTimeStamp();
    void updateTime();
    
    // triangulation + drawing
    void drawTrianglePaths();
    void updateNorthPoint();
    void updateTouchPoint();
    void drawLabelStats();
    void drawCompass();
    void addGridPointsRectangular();
    int centerAlignX(string s); //utility
    string pad(int value); //utility
    
    //gui events
    void checkKeyboardStuff();
    void onClickTextButton(int & i);
    void onSliderButton(int & i);
    void onImageButton(int & i);
    ofEventArgs	 voidEventArgs;
    
    // gps location/compass updates.
    void updateLocation();
    
    // core motion- accelerometer, gyroscope, magnetometer, attitude
    void updateCoreMotion();
    
    // should be in ofUtils.h
    string ofToStringAdaptive(double value, int precision);
    
};


