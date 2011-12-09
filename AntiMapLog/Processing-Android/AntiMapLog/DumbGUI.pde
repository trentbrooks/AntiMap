
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
 * DUMB GUI
 * extending examples in library under 'GUI'. includes a slider, text button, image button
 * quite customised, not sure how reusable - hence 'DumbGUI'.
 *
 * DumbGUI includes the following classes: Button, ImageButton, SliderButton, & TextButton.
 *
 */
 

// BASE BUTTON
/* ------------------------------------------------------ */
// simple button class for extending. circle/rect hittest area only.
class Button
{
  // props
  int x, y;
  int w, h;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false; 

  // check if mouse has been pressed
  void pressed() 
  {
    pressed = (over && mousePressed) ? true : false;
  }
  
  // check if mouse is hover over circular area
  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    
    return sqrt(sq(disX) + sq(disY)) < diameter/2;
  }
  
  // check if mouse is hover over a rectangular area
  boolean overRect(int x, int y, int width, int height) 
  {
    return mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height;
  }
}


// IMAGE PUSH BUTTON
/* ------------------------------------------------------ */
// class for a image button, with up/over state. pass screen pos (x,y) + image paths (up,over) to constructor
class ImageButton extends Button
{  
  boolean toggleSwitch;
  PImage upImage;
  PImage overImage;
  PImage currentimage;
  boolean isImageUp;

  // usage: ImageButton ib = new ImageButton(10, 10, "myButton.png", "myButtonOver.png");
  ImageButton(int xp, int yp, String upImagePath, String overImagePath)
  {
    x = xp;
    y = yp;

    upImage = loadImage(upImagePath); //loadImage("btnPlusA.png");
    overImage = loadImage(overImagePath); //loadImage("btnPlusB.png");

    w = upImage.width;
    h = upImage.height;

    isImageUp = true;  
    currentimage = upImage;
  }

  // check for all mouse interactions
  void update() 
  {
    overImage();
    pressed();
    
    // if mouse pressed set current image to the over image otherwise use up (default) image
    if (pressed) // mouse press
    {
      // switch the image once only
      if (isImageUp) 
      {
        currentimage = overImage; 
        isImageUp = false;
      }
      
      // set to false when mouse down, only toggles true when mouse is released (once)
      toggleSwitch= false;
    } 
    else if (over) // mouse over + release
    {
      // switch the image once only
      if (!isImageUp) 
      {
        currentimage = upImage; 
        isImageUp = true;
      }
      
      // false means the mouse was pressed, this switches it back to notify when 'mouse released'.
      if (!toggleSwitch) 
      {
        // let app know the button was touched (fake event, main app needs this method).
        // needs to return an identifier if multiple buttons are to be used- not implemented here.
        onClickImageButton();
        toggleSwitch = true; // mouse released?
      }
    }
    else // no mouse interaction
    {
      // switch the image once only
      if (!isImageUp) 
      {
        currentimage = upImage;
        isImageUp = true;
      }
      toggleSwitch= false;
    }
  }

  // same as hittest for a rectangle, except bounds are predefined.
  void overImage() 
  {
    over = ( overRect(x, y, w, h) ) ? true : false;
  }

  // displays image
  void display() 
  {
    image(currentimage, x, y);
  }
}


// TEXT PUSH BUTTON
/* ------------------------------------------------------ */
// custom text button with preset style  + colors (white text on gray rectangle bg). pass button label, screen pos (x,y) + button area (width, height) to constructor
// too much overlap here with the image button, need to update.
class TextButton extends Button
{
  String label = "CLICK ME";
  color bgColor = color(50, 255); //75
  color overColor = color(140, 0, 0, 255);
  color upColor = color(50, 255);
  boolean isColorUp;
  boolean toggleSwitch;

  // usage: TextButton tb txtBtn = new TextButton("Click me", 10, 10, 200, 10);
  TextButton(String lb, int xp, int yp, int wp, int hp)
  {
    label = lb;
    x = xp;
    y = yp;
    w = wp;
    h = hp;
    
    isColorUp = true; 
  }

  // check for all mouse interactions
  void update() 
  {
    overText();
    pressed();
    
    // if mouse pressed set current image to the over image otherwise use up (default) image
    if (pressed) // mouse press
    {
      // switch the background color once only
      if (isColorUp)
      {
        bgColor = overColor; 
        isColorUp = false;       
      }
      
      // set to false when mouse down, only toggles true when mouse is released (once)
      toggleSwitch= false;
    } 
    else if (over) // mouse over + release
    {
      // switch the background color once only
      if (!isColorUp) 
      {
        bgColor = upColor; 
        isColorUp = true;
      }
      
       // false means the mouse was pressed, this switches it back to notify when 'mouse released'.
      if (!toggleSwitch) 
      {
        // let app know the button was touched (fake event, main app needs this method).
        // needs to return an identifier if multiple buttons are to be used- not implemented here.
        onClickTextButton();
        toggleSwitch = true; // mouse released?
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
  void overText() 
  {
    over = ( overRect(x, y, w, h) ) ? true : false;
  }

  // display text and background rectangle
  void display() 
  {
    noStroke();
    fill(bgColor);
    rect(x, y, w, h);
    fill(255);
    //println(y + " " + int(sh -  27));
    text(label, alignTextX(label, int(halfScreenX)), int(sh -  27));
  }
}


// SLIDER
/* ------------------------------------------------------ */
// class for a slider. don't know if this is the best way to make a slider, but seems ok. 
class SliderButton extends Button 
{
  PImage bg;
  PImage base;
  PImage roll;
  PImage currentimage;
  float offsetBtnX;
  int bWidth;
  int bHeight;
  int touchWidth;
  float destX = 0;
  int buffer = 50;
  int slideMode = 0;
  boolean swiped;  
  float dragThreshold;
  int textXPos;
  String tagA = "";
  String tagB = "";
  String tagSelected;

  //usage: SliderButton sb = new SliderButton(sw/2 - 87, sh/2 + 15, 55, color(255), color(180, 0, 44));
  SliderButton(int ix, int iy, String msgSlideA, String msgSlideB) 
  {
    // positions
    x = ix;
    y = iy;    

    // messages
    tagA = msgSlideA;
    tagB = msgSlideB;
    tagSelected = tagA;

    // manually setting/loading the image files here
    bg = loadImage("sliderBg2.png");
    base = loadImage("sliderBtnA.png");
    roll = loadImage("sliderBtnB.png");
    currentimage = base;

    // slider bounds
    offsetBtnX = base.width/2;
    touchWidth = base.width;
    bWidth = bg.width;
    bHeight = bg.height;
    destX = x;

    // must drag more than 50% to register a completed action (absolute position)
    dragThreshold = sw * .5;//.66;    
    
    // manually offset the position of the text (change for different fonts/sizes)
    textXPos = int(destX + 117);
  }

  // same as hittest for a rectangle, except bounds are predefined.
  void overSlider() 
  {
    over = ( overRect(int(destX) - buffer, y-buffer, touchWidth + (buffer * 2), bHeight+(buffer * 2) )) ? true : false;
  }

  // check if slide action complete, then toggle for reverse slide.
  void swipeDetect()
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
        currentimage = roll;
        tagSelected = tagB;
        textXPos = int(x + 60);

        // let app know the slide action completed (fake event, main app needs this method).
        // needs to return an identifier if multiple sliders are to be used- not implemented here.
        onSliderButton();
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
        currentimage = base;
        tagSelected = tagA;
        textXPos = int(x + 117);

        // let app know the slide action completed (fake event, main app needs this method).
        // needs to return an identifier if multiple sliders are to be used- not implemented here.
        onSliderButton();
      }
    }
  }

  // check for all mouse interactions
  void update() 
  {
    overSlider();
    pressed();

    // detect swipes
    swipeDetect();

    // constrain the position when user dragging
    if (pressed) destX = constrain(mouseX-offsetBtnX, x, x + bWidth - touchWidth);
  }

  // display background image for slider, slider btn, and text
  void display() 
  {
    fill(0);
    stroke(0, 255);
    
    // background, text, then button
    image(bg, x, y);
    text(tagSelected, alignTextX(tagSelected, int(textXPos)), int(y + 43));
    image(currentimage, destX, y);
  }
}

