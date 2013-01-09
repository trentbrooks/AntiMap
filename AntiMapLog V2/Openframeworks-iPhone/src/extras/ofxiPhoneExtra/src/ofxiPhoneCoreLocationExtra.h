
/**
 * ofxiPhoneCoreLocationExtra
 * Modified by Trent Brooks, http://www.trentbrooks.com
 *
 * ------------------------------------------------------ 
 *
 * ABOUT
 * ofxiPhoneCoreLocationExtra is a modified version of Zach Gage's original addon ofxiPhoneCoreLocation.
 * Updates with speed (metres per second) from the CLLocationManager, and accumulates the distance.
 * Added new methods: getSpeed(); getCumulatedDistance(); resetCumulatedDistance(); hasLocationRecorded();
 *
 * Original:
 * Created by Zach Gage on 3/1/09.
 * Copyright 2009 stfj. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ofMain.h"
#pragma once


@interface ofxiPhoneCoreLocationExtraDelegate : NSObject <CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
	
	//location
	double lat;
	double lng;
	double hAccuracy;
	double alt;
	double vAccuracy;
	double distMoved;
    double gpsSpeed;
	//NSString * lastUpdatedLocationTimestamp
	
	//heading
	double x;
	double y;
	double z;
	double magneticHeading;
	double trueHeading;
	double headingAccuracy;
    bool locationRecorded;
    double cumulatedDistance;
    //double timePassed;
	//NSString * lastUpdatedCompasTimestamp
}

@property (nonatomic, readonly) double lat;
@property (nonatomic, readonly) double lng;
@property (nonatomic, readonly) double hAccuracy;
@property (nonatomic, readonly) double alt;
@property (nonatomic, readonly) double vAccuracy;
@property (nonatomic, readonly) double distMoved;
@property (nonatomic, readonly) double gpsSpeed;
@property (nonatomic, readonly) double x;
@property (nonatomic, readonly) double y;
@property (nonatomic, readonly) double z;
@property (nonatomic, readonly) double magneticHeading;
@property (nonatomic, readonly) double trueHeading;
@property (nonatomic, readonly) double headingAccuracy;
@property (nonatomic, readonly) bool locationRecorded;
@property (nonatomic, readonly) double cumulatedDistance;
//@property (nonatomic, readonly) double timePassed;

- (id) init;
- (void) dealloc;

- (bool) startHeading;
- (void) stopHeading;

- (bool) startLocation;
- (void) stopLocation;
- (void) resetCumulatedDistance;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

@end

class ofxiPhoneCoreLocationExtra
{
		
	public:
		
		ofxiPhoneCoreLocationExtra();
		~ofxiPhoneCoreLocationExtra();	
		
		bool startHeading();
		void stopHeading();
		
		bool startLocation();
		void stopLocation();
		
		double getLatitude();
		double getLongitude();
		double getLocationAccuracy();
		double getAltitude();
		double getAltitudeAccuracy();
		double getDistMoved();
		double getCompassX();
		double getCompassY();
		double getCompassZ();
		double getMagneticHeading();
		double getTrueHeading();
		double getHeadingAccuracy();
    
        // new methods
        double getSpeed();
        bool hasLocationRecorded();
        double getTimePassed();
        double getCumulatedDistance();
        void resetCumulatedDistance();
		
	protected:
	
		ofxiPhoneCoreLocationExtraDelegate *	coreLoc;
};