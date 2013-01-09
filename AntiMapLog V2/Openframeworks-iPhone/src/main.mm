#include "ofMain.h"
#include "AntiMapLog.h"

int main(){
	
    ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow();
	
	iOSWindow->enableDepthBuffer();
	iOSWindow->enableAntiAliasing(4);	
	iOSWindow->enableRetinaSupport();
	
	ofSetupOpenGL(iOSWindow, 480, 320, OF_FULLSCREEN);
	ofRunApp(new AntiMapLog);
}
