
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
 * DUMB GUI
 * ported from android project as best i could.
 * quite customised, not sure how reusable - hence 'DumbGUI'.
 *
 * DumbGUI includes the following classes: Button, ImageButton, SliderButton, & TextButton.
 *
 */


#ifndef OFXEVENTSADDON_H_
#define OFXEVENTSADDON_H_

#include "ofMain.h"
#include "ofEvents.h"

//: public ofSimpleApp, public ofxiPhoneAlertsListener, public ofxMultiTouchListener

// BASE BUTTON
/* ------------------------------------------------------ */
// simple button class for extending. circle/rect hittest area only.
class Button
{
    public:
        Button();    
    
        // props
        int x, y;
        int w, h;
        float mx, my; //mouse/touch position
        bool mouseIsDown;
        ofColor basecolor, highlightcolor;
        ofColor currentcolor;
        bool over;// = false;
        bool pressed;// = false; 
        
        //void update(int x, int y);
        void checkPressed();
        bool overCircle(int x, int y, int diameter);
        bool overRect(int x, int y, int w, int h);
    
        //dumb stuff
        ofTrueTypeFont vagFont;
        int centerAlignX(string s, int destX);
        float halfScreenX;
        float sw;
};



// IMAGE PUSH BUTTON
/* ------------------------------------------------------ */
// class for a image button, with up/over state. pass screen pos (x,y) + image paths (up,over) to constructor
class ImageButton : public Button
{  
    public:
    
        void setup(bool retina, int xp, int yp, string upImagePath, string overImagePath);
    
        bool toggleSwitch;
        ofImage upImage;
        ofImage overImg;
        ofImage *currentimage;
        bool isImageUp;
        
        void update(float tx, float ty);
        void overTheImage();
        void display();
        void setPosition(int xp, int yp);
    
        ofEvent<int> onImageButtonEvent;
};



// SLIDER
/* ------------------------------------------------------ */
// class for a slider. don't know if this is the best way to make a slider, but seems ok. 
class SliderButton : public Button
{
    public:
        
        void setup(bool retina, float stgWidth, int ix, int iy, string msgSlideA, string msgSlideB);
        
        ofImage bg;
        ofImage base;
        ofImage roll;
        ofImage *currentimage;
        float offsetBtnX;
        int bWidth;
        int bHeight;
        int touchWidth;
        float destX;// = 0;
        int buffer;// = 50;
        int slideMode;// = 0;
        bool swiped;  
        float dragThreshold;
        int textXPos;
        string tagA;// = "";
        string tagB;// = "";
        string tagSelected;
        // retina fixes (no magic numbers)
        int txtOffsetX_A;
        int txtOffsetX_B;
        int txtOffsetY;
            
        void overSlider();
        void swipeDetect();
        void update(float tx, float ty);
        void display();
    
        ofEvent<int> onSliderButtonEvent;        
};



// TEXT PUSH BUTTON
/* ------------------------------------------------------ */
// custom text button with preset style  + colors (white text on gray rectangle bg). pass button label, screen pos (x,y) + button area (width, height) to constructor
// too much overlap here with the image button, need to update.
class TextButton : public Button
{
    public:
    
        void setup(bool retina, string lb, int xp, int yp, int wp, int hp);
        
        string label;// = "CLICK ME";
        ofColor bgColor;// = color(50, 255); //75
        ofColor overColor;// = color(140, 0, 0, 255);
        ofColor upColor;// = color(50, 255);
        bool isColorUp;
        bool toggleSwitch;
        int txtOffsetY;
    
        void update(float tx, float ty);
        void overText();
        void display();
    
        ofEvent<int> onClickTextButtonEvent;    
};


#endif /* OFXEVENTSADDON_H_ */
