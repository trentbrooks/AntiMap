
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

#include "DumbGUI.h"


// BASE BUTTON
/* ------------------------------------------------------ */  
Button::Button() {
    over = false;
    pressed = false;
    mouseIsDown = false;
}

void Button::checkPressed() 
{
    pressed = (over && mouseIsDown) ? true : false;
}

bool Button::overCircle(int x, int y, int diameter) 
{
    float disX = x - mx;
    float disY = y - my;
    
    return sqrt((disX * disX) + (disY * disY)) < diameter/2;
}

bool Button::overRect(int x, int y, int w, int h) 
{
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
}


int Button::centerAlignX(string s, int destX)
{
    return int(destX - (vagFont.stringWidth(s) * .5));
}




// IMAGE BUTTON
/* ------------------------------------------------------ */  
void ImageButton::setup(bool retina, int xp, int yp, string upImagePath, string overImagePath) {
    x = xp;
    y = yp;
    
    upImage.loadImage(upImagePath); //loadImage("btnPlusA.png");
    overImg.loadImage(overImagePath); //loadImage("btnPlusB.png");
    if(!retina)
    {
        upImage.resize(upImage.width * .5, upImage.height * .5);
        overImg.resize(overImg.width * .5, overImg.height * .5);
    }
    
    w = upImage.width;
    h = upImage.height;
    
    isImageUp = true;  
    toggleSwitch = false;
    currentimage = &upImage;
}

void ImageButton::setPosition(int xp, int yp)
{
    x = xp;
    y = yp;
}

// check for all mouse interactions
void ImageButton::update(float tx, float ty) 
{
    mx = tx;
    my = ty;
    overTheImage();
    checkPressed();
    
    // if mouse pressed set current image to the over image otherwise use up (default) image
    if (pressed) // mouse press
    {
        if(over)
        {
            // switch the image once only
            if (isImageUp) 
            {
                currentimage = &overImg; 
                isImageUp = false;
            }            
            
            // false means the mouse was pressed, this switches it back to notify when 'mouse released'.
            if (!toggleSwitch) 
            {
                ofNotifyEvent(onImageButtonEvent,x);
                toggleSwitch = true; // mouse released?
            }
        }
        else
        {
            // set to false when mouse down, only toggles true when mouse is released (once)
            toggleSwitch= false; 
        }
        
    } 
    else // no mouse interaction
    {
        // switch the image once only
        if (!isImageUp) 
        {
            currentimage = &upImage;
            isImageUp = true;
        }
        
        toggleSwitch= false;
    }
}

// same as hittest for a rectangle, except bounds are predefined.
void ImageButton::overTheImage() 
{
    over = ( overRect(x, y, w, h) ) ? true : false;
}

// displays image
void ImageButton::display() 
{
    ofSetColor(255, 255, 255, 255);
    currentimage->draw(x, y);
}



// SLIDER BUTTON
/* ------------------------------------------------------ */  
void SliderButton::setup(bool retina, float stgWidth, int ix, int iy, string msgSlideA, string msgSlideB) {
    buffer = (retina) ? 50 : 25;
    destX = 0.0f;
    slideMode = 0;
        
    // positions
    x = ix;
    y = iy;    
    
    // messages
    tagA = msgSlideA;
    tagB = msgSlideB;
    tagSelected = tagA;
    
    // manually setting/loading the image files here
    bg.loadImage("sliderBg2_iphone.png");
    base.loadImage("sliderBtnA_iphone.png");
    roll.loadImage("sliderBtnB_iphone.png");
    currentimage = &base;
    if(!retina)
    {
        bg.resize(bg.width * .5, bg.height * .5);
        base.resize(base.width * .5, base.height * .5);
        roll.resize(roll.width * .5, roll.height * .5);
    }
    
    // slider bounds
    offsetBtnX = base.width/2;
    touchWidth = base.width;
    bWidth = bg.width + ((retina) ? 3 : 0); // have to add 3 px for retina to make sure it covers the bg
    bHeight = bg.height;
    destX = x;
    
    // must drag more than 50% to register a completed action (absolute position)
    sw = stgWidth;
    dragThreshold = sw * .5;//.66;    
    
    // manually offset the position of the text (change for different fonts/sizes)
    txtOffsetX_A = (retina) ? 140 : 70;
    txtOffsetX_B = (retina) ? 70 : 35;
    txtOffsetY = (retina) ? 50 : 25;
    textXPos = int(destX + txtOffsetX_A);
}

// same as hittest for a rectangle, except bounds are predefined.
void SliderButton::overSlider() 
{
    over = ( overRect(int(destX) - buffer, y-buffer, touchWidth + (buffer * 2), bHeight+(buffer * 2) )) ? true : false;
}

// check if slide action complete, then toggle for reverse slide.
void SliderButton::swipeDetect()
{
    // reset the swipe every frame 
    swiped = false;
    
    // here always snap the button to either side - when NOT pressed. checking for completed actions.
    if ((destX + offsetBtnX) > dragThreshold)
    {
        // update the destX test position
        destX =  x + bWidth - touchWidth;
        
        // sliding left to right completed
        if (slideMode == 0) 
        {
            swiped = true;
            slideMode = 1;
            currentimage = &roll;
            tagSelected = tagB;
            textXPos = int(x + txtOffsetX_B);
            
            ofNotifyEvent(onSliderButtonEvent,x);
        }
    }
    else if ((destX + offsetBtnX) < dragThreshold)
    {
        // update the destX test position
        destX = x;
        
        // sliding right to left completed
        if (slideMode == 1) 
        {
            swiped = true;
            slideMode = 0;
            currentimage = &base;
            tagSelected = tagA;
            textXPos = int(x + txtOffsetX_A);
            
            ofNotifyEvent(onSliderButtonEvent,x);
        }
    }
}

// check for all mouse interactions
void SliderButton::update(float tx, float ty) 
{
    mx = tx;
    my = ty;
    overSlider();
    checkPressed();
    
    // detect swipes
    swipeDetect();
    
    // constrain the position when user dragging
    if (pressed) destX = ofClamp(mx-offsetBtnX, x, x + bWidth - touchWidth);
}

// display background image for slider, slider btn, and text
void SliderButton::display() 
{
    // background, text, then button
    ofSetColor(255, 255, 255);
    bg.draw(x, y);
    ofSetColor(0,0,0);
    vagFont.drawString(tagSelected, centerAlignX(tagSelected, int(textXPos)), int(y + txtOffsetY));
    ofSetColor(255, 255, 255);
    currentimage->draw(destX, y);
}



// SLIDER BUTTON
/* ------------------------------------------------------ */ 
void TextButton::setup(bool retina, string lb, int xp, int yp, int wp, int hp)
{
    halfScreenX = 0;
    bgColor= ofColor(50, 50, 50, 255);
    overColor= ofColor(140, 0, 0, 255);
    upColor= ofColor(50, 50, 50, 255);
    
    label = lb;
    x = xp;
    y = yp;
    w = wp;
    h = hp;
    
    toggleSwitch = false;
    isColorUp = true; 
    
    txtOffsetY = (retina) ? 24 : 12;
}

// check for all mouse interactions
void TextButton::update(float tx, float ty) 
{
    mx = tx;
    my = ty;
    overText();
    checkPressed();
    
    // if mouse pressed set current image to the over image otherwise use up (default) image
    if (pressed) // mouse press
    {
        if (over)
        {
            // switch the background color once only
            if (isColorUp)
            {
                bgColor = overColor; 
                isColorUp = false;       
            }
            
            // false means the mouse was pressed, this switches it back to notify when 'mouse released'.
            if (!toggleSwitch) 
            {
                toggleSwitch = true; // mouse released?
                
                 ofNotifyEvent(onClickTextButtonEvent,x);
            }
        }
        else
        {            
            // set to false when mouse down, only toggles true when mouse is released (once)
            toggleSwitch= false; 
        }
        
    } 
    else // no mouse interaction
    {
        // switch the background color once only
        if (!isColorUp) 
        {
            bgColor = upColor;
            isColorUp = true;
        }
        toggleSwitch= false;
    }
}

// same as hittest for a rectangle, except bounds are predefined.
void TextButton::overText() 
{
    over = ( overRect(x, y, w, h) ) ? true : false;
}

// display text and background rectangle
void TextButton::display() 
{
    ofSetColor(bgColor);
    ofRect(x, y, w, h);
    ofSetColor(255,255,255);
    vagFont.drawString(label, centerAlignX(label, int(halfScreenX)), int(y + txtOffsetY));
}


