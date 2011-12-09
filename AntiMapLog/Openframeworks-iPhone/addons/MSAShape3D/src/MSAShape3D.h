/***********************************************************************
 
 Copyright (c) 2008, 2009, 2010, Memo Akten, www.memo.tv
 *** The Mega Super Awesome Visuals Company ***
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/ 

/***************
 DEPENDENCIES:
 - none
 ***************/ 

#pragma once

namespace MSA {
	
#define DEFAULT_RESERVE_AMOUNT		5000
#define SIZEOF_FLOAT				4		// TODO: make this dynamic
	
	//#define USE_IMMEDIATE_MODE		// uncomment this to use immediate mode (to compare performance / behaviour etc.)
	
	class Shape3D {
	public:
		Shape3D();
		~Shape3D();
		
		
		// reserve space for this many vertices
		// Not actually nessecary, arrays are resized automatically...
		// ... but reserving the size upfront improves performance
		void reserve(int reservedSize);
		
		
		// similar to OpenGL glBegin
		// starts primitive draw mode
		void begin(GLenum drawMode);
		
		
		// similar to OpenGL glEnd()
		// sends all data to server to be drawn
		void end();
		
		
		// redraws currently cached shape
		void draw();
		
		
		// vertex position methods
		// x,y,z coordinates (if z is omitted, assumed 0)	
		void addVertex(float x, float y, float z = 0);
		
		
		// pointer to x,y,z coordinates
		void addVertex3v(float *v);
		
		
		// pointer to x,y coordinates. z is assumed 0
		void addVertex2v(float *v);
		
		
		// normal methods
		// x,y,z components of normal
		void setNormal(float x, float y, float z);
		
		
		// pointer to x,y,z components of normal
		void setNormal3v(float *v);
		
		
		// color methods
		// r,g,b,a color components (if a is omitted, assumed 0)	
		void setColor(float r, float g, float b, float a = 1);
		
		
		// 0xFFFFFF hex color, alpha is assumed 1	
		void setColor(int hexColor);
		
		
		// pointer to r,g,b components. alpha is assumed 1
		void setColor3v(float *v);
		
		
		// pointer to r,g,b,a components
		void setColor4v(float *v);
		
		
		// texture coordinate methods
		// u,v texture coordinates
		void setTexCoord(float u, float v);
		
		
		// pointer to u,v texture coordinates
		void setTexCoord2v(float *v);
		
		
		// rectangle from (x1, y1) to (x2, y2)
		void drawRect(float x1, float y1, float x2, float y2) ;
		
		
		
		
		/********* Advanced use ***********/
		
		// safe mode is TRUE by default
		// if safe mode is on, all clientstates are set as needed in end()
		// this may not be efficient if lots of shapes are drawn
		// by disabling safe mode, you can manually set the clientstates (using the below methods)
		// and avoid this overhead
		// if you don't know what this means, don't touch it
		void setSafeMode(bool b);
		
		
		// set whether the shape will be using any of the below
		void enableNormal(bool b);
		void enableColor(bool b);
		void enableTexCoord(bool b);
		
		// enables or disables all client states based on information provided in above methods
		void setClientStates();
		void restoreClientStates();
		
		
	protected:
		void reset();
		void restoreState(int flag, bool curState, bool oldState);
		
		
		float	*vertexArray;	// 3
		float	*normalArray;	// 3
		float	*colorArray;	// 4
		float	*texCoordArray;	// 2
		int		sizeOfFloat;
		
		
		float	curNormal[3];
		float	curColor[4];
		float	curTexCoord[2];
		
		bool	normalEnabled;
		bool	colorEnabled;
		bool	texCoordEnabled;
		
		bool	normalWasEnabled;
		bool	colorWasEnabled;
		bool	texCoordWasEnabled;
		
		bool	safeMode;
		
		int		numVertices;
		int		vertexIndex;
		//	int		normalIndex;
		//	int		colorIndex;
		//	int		texCoordIndex;	
		
		int		reservedSize;
		GLenum	drawMode;
	};
	
	
	/******************** IMPLEMENTATION ************************/
	
	inline Shape3D::Shape3D() {
		vertexArray = normalArray = colorArray = texCoordArray = 0;
		colorEnabled = normalEnabled = texCoordEnabled = false;
		setSafeMode(true);
		reserve(DEFAULT_RESERVE_AMOUNT);
	}
	
	inline Shape3D::~Shape3D() {
		if(vertexArray) free(vertexArray);
		if(normalArray) free(normalArray);
		if(colorArray) free(colorArray);
		if(texCoordArray) free(texCoordArray);	
	}
	

	inline void Shape3D::reserve(int reservedSize) {
		this->reservedSize = reservedSize;
		
		vertexArray		= (float*)realloc(vertexArray, 3 * reservedSize * SIZEOF_FLOAT);
		normalArray		= (float*)realloc(normalArray, 3 * reservedSize * SIZEOF_FLOAT);
		colorArray		= (float*)realloc(colorArray, 4 * reservedSize * SIZEOF_FLOAT);
		texCoordArray	= (float*)realloc(texCoordArray, 2 * reservedSize * SIZEOF_FLOAT);
		
		if(safeMode == false) setClientStates();
		
		reset();
	}
	
	inline void Shape3D::begin(GLenum drawMode) {
#ifndef USE_IMMEDIATE_MODE
		this->drawMode = drawMode;
		reset();
#else	
		glBegin(drawMode);
#endif	
	}
	

	inline void Shape3D::end() {
#ifndef USE_IMMEDIATE_MODE
		if(safeMode) setClientStates();
		glDrawArrays(drawMode, 0, numVertices);
		if(safeMode) restoreClientStates();
#else
		glEnd();
#endif	
	}
	

	inline void Shape3D::draw() {
		this->end();
	}
	
	
	inline void Shape3D::addVertex(float x, float y, float z) {
#ifndef USE_IMMEDIATE_MODE
		if(safeMode) {
			if(numVertices >= reservedSize) reserve(reservedSize * 1.1);      // if we hit limit, increase reserve by 10%
			memcpy(normalArray + numVertices*3, curNormal, 3*SIZEOF_FLOAT);
			memcpy(colorArray + numVertices*4, curColor, 4*SIZEOF_FLOAT);
			memcpy(texCoordArray + numVertices*2, curTexCoord, 2*SIZEOF_FLOAT);
		} else {
			if(normalEnabled) memcpy(normalArray + numVertices*3, curNormal, 3*SIZEOF_FLOAT);
			if(colorEnabled) memcpy(colorArray + numVertices*4, curColor, 4*SIZEOF_FLOAT);
			if(texCoordEnabled) memcpy(texCoordArray + numVertices*2, curTexCoord, 2*SIZEOF_FLOAT);
		}
		
		vertexArray[vertexIndex++]      = x;
		vertexArray[vertexIndex++]      = y;
		vertexArray[vertexIndex++]      = z;
		
		numVertices++;
#else
		glVertex3f(x, y, z);
#endif   
	}
	
	inline void Shape3D::addVertex3v(float *v) {
		this->addVertex(v[0], v[1], v[2]);
	}					
	
	inline void Shape3D::addVertex2v(float *v) {
		this->addVertex(v[0], v[1]);
	}						
	
	inline void Shape3D::setNormal(float x, float y, float z) {
#ifndef USE_IMMEDIATE_MODE
		if(safeMode) normalEnabled = true;
		curNormal[0] = x;
		curNormal[1] = y;
		curNormal[2] = z;
#endif
		glNormal3f(x, y, z);
	}
	
	
	inline void Shape3D::setNormal3v(float *v) {
		this->setNormal(v[0], v[1], v[2]);
	}

	
	inline void Shape3D::setColor(float r, float g, float b, float a) {
#ifndef USE_IMMEDIATE_MODE
		if(safeMode) colorEnabled = true;
		curColor[0] = r;
		curColor[1] = g;
		curColor[2] = b;
		curColor[3] = a;
#endif	
		glColor4f(r, g, b, a);
	}
	

	inline void Shape3D::setColor(int hexColor) {
		float r = ((hexColor >> 16) & 0xff) * 1.0f/255;
		float g = ((hexColor >> 8) & 0xff)  * 1.0f/255;
		float b = ((hexColor >> 0) & 0xff)  * 1.0f/255;
		this->setColor(r, g, b);
	}		
	

	inline void Shape3D::setColor3v(float *v) {
		this->setColor(v[0], v[1], v[2]);
	}						
	

	inline void Shape3D::setColor4v(float *v) {
		this->setColor(v[0], v[1], v[2], v[3]);		
	}						
	
	
	inline void Shape3D::setTexCoord(float u, float v) {
#ifndef USE_IMMEDIATE_MODE
		if(safeMode) texCoordEnabled = true;
		curTexCoord[0] = u;
		curTexCoord[1] = v;
#else		
		glTexCoord2f(u, v);
#endif	
	}				
	

	inline void Shape3D::setTexCoord2v(float *v) {
		this->setTexCoord(v[0], v[1]);
	}					
	
	
	inline void Shape3D::drawRect(float x1, float y1, float x2, float y2) {
		this->begin(GL_TRIANGLE_STRIP);
		this->addVertex(x1, y1);
		this->addVertex(x2, y1);
		this->addVertex(x1, y2);
		this->addVertex(x2, y2);
		this->end();
	}
	
	
	
	/********* Advanced use ***********/
	
	inline void Shape3D::setSafeMode(bool b) {
		safeMode = b;
	}
	
	inline void Shape3D::enableNormal(bool b) {
		if(safeMode) normalWasEnabled = glIsEnabled(GL_NORMAL_ARRAY);
		if(normalEnabled = b) {
			glEnableClientState(GL_NORMAL_ARRAY);
			glNormalPointer(GL_FLOAT, 0, &normalArray[0]);
		}
		else glDisableClientState(GL_NORMAL_ARRAY);
	}
	
	inline void Shape3D::enableColor(bool b) {
		if(safeMode) colorWasEnabled = glIsEnabled(GL_COLOR_ARRAY);
		if(colorEnabled = b) {
			glEnableClientState(GL_COLOR_ARRAY);
			glColorPointer(4, GL_FLOAT, 0, &colorArray[0]);
		}
		else glDisableClientState(GL_COLOR_ARRAY);	
	}
	
	inline void Shape3D::enableTexCoord(bool b) {
		if(safeMode) texCoordWasEnabled = glIsEnabled(GL_TEXTURE_COORD_ARRAY);
		if(texCoordEnabled = b) {
			glEnableClientState(GL_TEXTURE_COORD_ARRAY);
			glTexCoordPointer(2, GL_FLOAT, 0, &texCoordArray[0]);
		}
		else glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	}
	
	inline void Shape3D::setClientStates() {
		enableColor(colorEnabled);
		enableNormal(normalEnabled);
		enableTexCoord(texCoordEnabled);
		glEnableClientState(GL_VERTEX_ARRAY);
		glVertexPointer(3, GL_FLOAT, 0, &vertexArray[0]);
	}
	
	inline void Shape3D::restoreClientStates() {
		restoreState(GL_NORMAL_ARRAY, normalEnabled, normalWasEnabled);
		restoreState(GL_COLOR_ARRAY, colorEnabled, colorWasEnabled);
		restoreState(GL_TEXTURE_COORD_ARRAY, texCoordEnabled, texCoordWasEnabled);
	}
	
	
	inline void Shape3D::reset() {
		if(safeMode) {
			colorEnabled		= false;
			normalEnabled		= false;
			texCoordEnabled		= false;
		}
		numVertices			= 0;
		
		vertexIndex = 0;
		//		normalIndex = colorIndex = texCoordIndex = 0;
	}
	
	inline void Shape3D::restoreState(int flag, bool curState, bool oldState) {
		if(curState == oldState) return;
		if(oldState) glEnableClientState(flag);
		else glDisableClientState(flag);
		curState = oldState;
	}
	
	
	
}
