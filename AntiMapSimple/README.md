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

More information: [http://www.theantimap.com](http://theantimap.com)

-Trent Brooks