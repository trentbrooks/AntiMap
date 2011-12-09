
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

#include "ofMain.h"
#include "AntiMapLog.h"
#include "ofxiPhoneExtras.h"

//AntiMapLog *myApp;
int main(){
	//ofSetupOpenGL(1024,768, OF_FULLSCREEN);			// <-------- setup the GL context

	ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow();
	
	iOSWindow->enableDepthBuffer();
	iOSWindow->enableAntiAliasing(4);
	
	iOSWindow->enableRetinaSupport();
	
	ofSetupOpenGL(iOSWindow, 480, 320, OF_FULLSCREEN);
    
    //myApp = new AntiMapLog;
	ofRunApp(new AntiMapLog);
}
