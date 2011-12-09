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


#include "ofxDelaunayExtra.h"

ofxDelaunayExtra::ofxDelaunayExtra(int maxPoints){
	p = NULL;
	v = NULL;
	this->init(maxPoints);
}

ofxDelaunayExtra::~ofxDelaunayExtra(){
	if(p != NULL){
		delete []p;
		p = NULL;
	}
	if(v != NULL){
		delete []v;
		v = NULL;
	}
}

void ofxDelaunayExtra::init(int maxPoints){
	this->maxPoints = maxPoints;
	this->reset();
}

void ofxDelaunayExtra::reset(){
	if(p != NULL)
		delete []p;
	p = new XYZ[this->maxPoints];
	if(v != NULL)
		delete []v;
	v = NULL;
	nv = 0;
	ntri = 0;
	
}

int ofxDelaunayExtra::addPoint(float x, float y, float z){
	if (nv >= this->maxPoints){
		this->maxPoints = this->maxPoints * 2;            // double the size of the array if necessary
		XYZ *p_Temp = new XYZ[this->maxPoints];
		for (int i = 0; i < nv; i++)
			p_Temp[i] = p[i];
		delete []p;
		p = p_Temp; 
	}
	p[nv].x = x;
	p[nv].y = y;
	p[nv].z = z;
	nv++;
	return nv;
}

void ofxDelaunayExtra::triangulateExtra(vector<ofVec2f*>& pts)
{
    reset();
    for(int i=0; i < pts.size(); i++){
        addPoint(pts[i]->x, pts[i]->y);
	}
    triangulate();
	
}

int ofxDelaunayExtra::triangulate(){
    
	XYZ *p_Temp = new XYZ[nv + 3]; 
	for (int i = 0; i < nv; i++)
		p_Temp[i] = p[i];      
	delete []p;
	p = p_Temp;
	v = new ITRIANGLE[3 * nv]; 
     
	qsort(p, nv, sizeof(XYZ), XYZCompare);
	Triangulate(nv, p, v, ntri);
	return ntri;
}

int ofxDelaunayExtra::getNumTriangles(){
	return this->ntri;
}

ITRIANGLE* ofxDelaunayExtra::getTriangles(){
	return this->v;
}

XYZ* ofxDelaunayExtra::getPoints(){
	return this->p;
}

void ofxDelaunayExtra::outputTriangles(){
	cout << "triangle count: " << ntri << endl;
	for(int i = 0; i < ntri; i++){
		cout << "triangle #" << i << endl;;
		cout << "\t" << (int)p[v[i].p1].x << "," << (int)p[v[i].p1].y << " " << (int)p[v[i].p2].x << "," << (int)p[v[i].p2].y << endl;
		cout << "\t" << (int)p[v[i].p2].x << "," << (int)p[v[i].p2].y << " " << (int)p[v[i].p3].x << "," << (int)p[v[i].p3].y << endl;
		cout << "\t" << (int)p[v[i].p3].x << "," << (int)p[v[i].p3].y << " " << (int)p[v[i].p1].x << "," << (int)p[v[i].p1].y << endl;
		cout << endl;
	}
}

void ofxDelaunayExtra::drawTriangles(){
	for(int i = 0; i < ntri; i++){
		/*
        ofSetColor(0, 255, 0);
		ofFill();
		ofTriangle(p[v[i].p1].x, p[v[i].p1].y, p[v[i].p2].x, p[v[i].p2].y, p[v[i].p3].x, p[v[i].p3].y);
		ofSetColor(0, 0, 255);
		ofNoFill();
		ofTriangle(p[v[i].p1].x, p[v[i].p1].y, p[v[i].p2].x, p[v[i].p2].y, p[v[i].p3].x, p[v[i].p3].y);
        */
        
        glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
		glEnable(GL_LINE_SMOOTH);
        //glLineWidth(.5);
        
        
		
        // points/colors seem to be swapping or flickering to often... need fix
		myTriangle.begin(GL_TRIANGLES);
		//myTriangle.setColor(.9, .9, .9, 1);
        myTriangle.setColor(.5, .5, .5, 1);
		myTriangle.addVertex(p[v[i].p1].x, p[v[i].p1].y,0);
		myTriangle.setColor(1, 1, 1, 1);
		myTriangle.addVertex(p[v[i].p2].x, p[v[i].p2].y,0);
		myTriangle.addVertex(p[v[i].p3].x, p[v[i].p3].y,0);
		myTriangle.end();
        
        
		myTriangleOutline.begin(GL_LINE_LOOP);
        //myTriangleOutline.
		myTriangleOutline.setColor(0.7,0.7,0.7, 1);
		myTriangleOutline.addVertex(p[v[i].p1].x, p[v[i].p1].y,0);
		myTriangleOutline.addVertex(p[v[i].p2].x, p[v[i].p2].y,0);
		myTriangleOutline.addVertex(p[v[i].p3].x, p[v[i].p3].y,0);
		myTriangleOutline.end();
	}
}
