/**
 * ofxiPhoneKeyboardExtra
 * Modified by Trent Brooks, http://www.trentbrooks.com
 *
 * ------------------------------------------------------ 
 *
 * ABOUT
 * ofxiPhoneKeyboardExtra is a modified version of Zach Gage's original addon ofxiPhoneKeyboard.
 * Added new methods: closeKeyboard(); disableAutoCorrection();
 *
 * Original:
 * Created by Zach Gage on 3/1/09.
 * Copyright 2009 stfj. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>
#import "ofMain.h"
#import "ofxiPhoneExtras.h"
#pragma once

@interface ofxiPhoneKeyboardExtraDelegate : NSObject <UITextFieldDelegate>
{
	UITextField*			_textField;
	bool					open;
	char *					_ctext;
	int						_x;
	int						_y;
	int						_w;
	int						_h;
	int						fieldLength;
}
- (id) init: (int)x y:(int)y width:(int)w height:(int)h;
- (void) showText;
- (void) hideText;  
- (char *) getText;
- (const char*) getLabelText;
- (void) setText: (NSString *)text;
- (void) setFontSize: (int)size;
- (void) setFontColorRed: (int)r green: (int)g blue:(int)b alpha:(int)a;
- (void) setBgColorRed: (int)r green: (int)g blue:(int)b alpha:(int)a;
- (bool) isKeyboardShowing;
- (void) setFrame: (CGRect) rect;
- (void) setPlaceholder: (NSString *)text;
- (void) openKeyboard;
- (void) updateOrientation;
- (void) makeSecure;
- (void) setFieldLength: (int)len;

// NEW METHODS
- (void) hideKeyboard;
- (void) disableAutoCorrection;  

@end

class ofxiPhoneKeyboardExtra
{
	
public:
	
	ofxiPhoneKeyboardExtra(int _x, int _y, int _w, int _h);
	~ofxiPhoneKeyboardExtra();
	
	void setVisible(bool visible);
	
	void setPosition(int _x, int _y);
	void setSize(int _w, int _h);
	void setFontSize(int ptSize);
	void setFontColor(int r, int g, int b, int a);
	void setBgColor(int r, int g, int b, int a);
	void setText(string _text);
	void setPlaceholder(string _text);
	void openKeyboard();
	void updateOrientation();
	void makeSecure();
	void setMaxChars(int max);
	
	string getText();
	string getLabelText();
	bool isKeyboardShowing();
    
    // NEW METHODS
    void closeKeyboard();
    void disableAutoCorrection();  
	
	
	
protected:
	
	ofxiPhoneKeyboardExtraDelegate *	keyboard;
	int x,y,w,h;
};