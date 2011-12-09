## About##
The AntiMap is an Open Source creative toolset for recording and visualising your own data. The project currently consists of a smart phone utility application (AntiMap Log) for data capture, and a couple of web/desktop applications (AntiMap Simple and AntiMap Video) for post analysis and data visualisation. In the coming months further applications, source code, and tutorials will be released in hope that users can learn from and find interesting ways to visualise data and use their technology.

## About AntiMap Log##
AntiMap Log is a smart phone utility application for ‘recording’ your own data.

Android/Processing:
- Created in Processing 1.5.
- Requires: Android SDK (http://wiki.processing.org/w/Android).
- Libraries: apwidgets.jar (http://code.google.com/p/apwidgets/) & triangulate.jar (http://wiki.processing.org/w/Triangulation) to be added to the 'code' folder.
- Permissions: ACCESS_FINE_LOCATION, WRITE_EXTERNAL_STORAGE

iPhone/Openframeworks:
- Created in Openframeworks 007.
- Addons: ofxTBiPhone, ofxTBDelaunay, MSAShape3D (https://github.com/memo/msalibs/tree/master/MSAShape3D)
- Custom properties to add: Under TARGETS > AntiMapLog, under the 'Info' tab, where it says 'Custom IOS Target Properties' you need to add 'Application supports iTunes file sharing' and set to 'YES'.


## About AntiMap Simple##
AntiMap Simple is a HTML5/ProcessingJS demo that visualises data from the AntiMap Log mobile application. To test it out on your local machine you need to be running localhost, or alternatively upload somewhere. 

Includes:
- Sample data from AntiMap Log mobile application- "040811_1153_30.csv".
- Inline processingjs code in the index.html (doesn't require Processing app to edit)
- AntiMapSimple.pde for editing in Processing
- processing-1.3.6.js library

If you don't want to work with the inline processingjs code, switch the commented out bits in the index.html so it loads the AntiMapSimple.pde directly:

<!-- external PDE (requires processing) -->
<canvas data-processing-sources="AntiMapSimple.pde" >

<!-- inline -->
<!--<canvas id="targetcanvas"></canvas>-->


## About AntiMap Video##
AntiMap Video is a desktop application built in Openframeworks. It synchronises recorded data from the AntiMap Log mobile application with raw video footage (mov, avi, mp4, m4v). It was originally created as a snowboarding/skiing application to visualize real time rider data and stats similar to a video game. 

AntiMap Video (version 0.1) is still an early prototype with plenty of kinks to work out before a 1.0 can be released. You can download the current working prototype application here (OSX only). Source code, and a windows version is not yet available but is definitely on the TODO list.

Includes:
- Sample data from AntiMap Log mobile application- "DATA_SAMPLE.csv".
- Sample video- "VIDEO_SAMPLE.mp4" (this is a compressed version of the original GoPro HD video which was 4 minutes long and 380mb, it is now 45 seconds and 10mb).

Further installation/setup instructions to come.

More information: [http://www.theantimap.com](http://theantimap.com)

-Trent Brooks