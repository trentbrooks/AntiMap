## About##
The AntiMap is an Open Source creative toolset for recording and visualising your own data. The project currently consists of a smart phone utility application (AntiMap Log) for data capture, and a couple of web/desktop applications (AntiMap Simple and AntiMap Video) for post analysis and data visualisation. 


## About AntiMap Log##
AntiMap Log is a smart phone utility application for ‘recording’ your own data.

####Android/Processing:####
 - Created in Processing 1.5.
 - Requires: Android SDK (http://wiki.processing.org/w/Android).
 - Libraries: apwidgets.jar (http://code.google.com/p/apwidgets/) & triangulate.jar (http://wiki.processing.org/w/Triangulation) to be added to the 'code' folder.
 - Permissions: ACCESS_FINE_LOCATION, WRITE_EXTERNAL_STORAGE

####iPhone/Openframeworks:####
 - Created in Openframeworks 007.
 - Addons: ofxTBiPhone, ofxTBDelaunay, MSAShape3D (https://github.com/memo/msalibs/tree/master/MSAShape3D)
 - Custom properties to add: Under TARGETS > AntiMapLog, under the 'Info' tab, where it says 'Custom IOS Target Properties' you need to add 'Application supports iTunes file sharing' and set to 'YES'.


## About AntiMap Simple##
AntiMap Simple is a HTML5/ProcessingJS demo that visualises data from the AntiMap Log mobile application. To test it out on your local machine you need to be running localhost, or alternatively upload somewhere. 

####Includes:####
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

AntiMap Video (version 0.2) is still an early prototype with plenty of kinks to work out before a 1.0 can be released. You can download the current working prototype application here (OSX only). Source code, and a windows version is not yet available but is definitely on the TODO list.

####Updates:####
AntiMap Video 0.2 now includes hi quality HD video exporting from the application. There is an issue when trying to use a h264 encoded mp4 video file and exporting, if this happens just convert your video to .mov or .avi before importing into the application.

####Download link:####
[https://github.com/downloads/trentbrooks/AntiMap/_AntiMapVideoApplication_02.zip](https://github.com/downloads/trentbrooks/AntiMap/_AntiMapVideoApplication_02.zip)

####Includes:####
 - Sample data from AntiMap Log mobile application- "DATA_SAMPLE.csv".
 - Sample video- "VIDEO_SAMPLE.mp4" (this is a compressed version of the original GoPro HD video which was 4 minutes long and 380mb, it is now 45 seconds and 10mb).

####Important:####
I purposely set the included video sample to be 1.5 seconds ahead of the data. Once you drag and drop both files onto the application you can adjust the individual timelines or the 'Video/Data time offset' to equal -1.5 seconds. Then everything will be in sync.


More information: [http://www.theantimap.com](http://theantimap.com)

-Trent Brooks
