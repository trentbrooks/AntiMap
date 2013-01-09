
/**
 * ofxDelaunayExtra
 * Modified by Trent Brooks, http://www.trentbrooks.com
 *
 * ------------------------------------------------------ 
 *
 * ABOUT
 * ofxDelaunayExtra is a modified version of Pat Longs original addon here: http://forum.openframeworks.cc/index.php?topic=2780.0
 * Adds simple triangulation from a set of points. Modified to work similar to this processing implementation: http://wiki.processing.org/w/Triangulation. New method: triangulateExtra(setOfPoints); 
 * 
 * Addons: MSAShape3D (https://github.com/memo/msalibs/tree/master/MSAShape3D)
 *
 * Original:
 * Created by Pat Long on 29/10/09.
 * Copyright 2009 Tangible Interaction. All rights reserved.
 * Some parts based on demo code by Gilles Dumoulin. 
 * Source: http://local.wasp.uwa.edu.au/~pbourke/papers/triangulate/cpp.zip
 *
 */

#ifndef _OFX_DELAUNAY
#define _OFX_DELAUNAY

#include "ofMain.h"

#include "../libs/Delaunay/Delaunay.h"
#include "MSAShape3D.h"

#define DEFAULT_MAX_POINTS 500

class ofxDelaunayExtra{
private:
	int maxPoints;
	ITRIANGLE *v;
	XYZ *p;
	int nv;
	int ntri;
	
public:
	ofxDelaunayExtra(int maxPoints=DEFAULT_MAX_POINTS);
	~ofxDelaunayExtra();
	
	void init(int maxPoints=DEFAULT_MAX_POINTS);
	void reset();
	
	int addPoint(float x=0.0, float y=0.0, float z=0.0);
	int triangulate();
	
	int getNumTriangles();
	ITRIANGLE* getTriangles();
	XYZ* getPoints();
	
	void outputTriangles();
	void drawTriangles();	
    
    // new methods
    MSA::Shape3D	myTriangle;
	MSA::Shape3D	myTriangleOutline;
    void triangulateExtra(vector<ofVec2f*>& pts);
   
};

#endif
