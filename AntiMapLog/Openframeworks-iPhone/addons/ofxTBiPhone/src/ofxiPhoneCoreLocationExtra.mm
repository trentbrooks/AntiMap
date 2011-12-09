
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

#import "ofxiPhoneCoreLocationExtra.h"

//C++ class implementations

//--------------------------------------------------------------
ofxiPhoneCoreLocationExtra::ofxiPhoneCoreLocationExtra()
{
	coreLoc = [[ofxiPhoneCoreLocationExtraDelegate alloc] init];
}

//--------------------------------------------------------------
ofxiPhoneCoreLocationExtra::~ofxiPhoneCoreLocationExtra()
{
	[coreLoc release];
}

//--------------------------------------------------------------

bool ofxiPhoneCoreLocationExtra::startHeading()
{
	return [coreLoc startHeading];
}

//--------------------------------------------------------------

void ofxiPhoneCoreLocationExtra::stopHeading()
{
	[coreLoc stopHeading];
}

//--------------------------------------------------------------
bool ofxiPhoneCoreLocationExtra::startLocation()
{
	return [coreLoc startLocation];
}

//--------------------------------------------------------------
void ofxiPhoneCoreLocationExtra::stopLocation()
{
	[coreLoc stopLocation];
}

//--------------------------------------------------------------

double ofxiPhoneCoreLocationExtra::getLatitude()
{
	return [coreLoc lat];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getLongitude()
{
	return [coreLoc lng];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getLocationAccuracy()
{
	return [coreLoc hAccuracy];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getAltitude()
{
	return [coreLoc alt];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getAltitudeAccuracy()
{
	return [coreLoc vAccuracy];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getDistMoved()
{
	return [coreLoc distMoved];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getCompassX()
{
	return [coreLoc x];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getCompassY()
{
	return [coreLoc y];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getCompassZ()
{
	return [coreLoc z];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getMagneticHeading()
{
	return [coreLoc magneticHeading];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getTrueHeading()
{
	return [coreLoc trueHeading];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getHeadingAccuracy()
{
	return [coreLoc headingAccuracy];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getSpeed()
{
	return [coreLoc gpsSpeed];
}

bool ofxiPhoneCoreLocationExtra::hasLocationRecorded()
{
	return [coreLoc startHeading];
}

//--------------------------------------------------------------
double ofxiPhoneCoreLocationExtra::getCumulatedDistance()
{
	return [coreLoc cumulatedDistance];
}

//--------------------------------------------------------------
void ofxiPhoneCoreLocationExtra::resetCumulatedDistance()
{
	[coreLoc resetCumulatedDistance];
}

/*
double ofxiPhoneCoreLocation::getTimePassed()
{
	return [coreLoc timePassed];
}
 */


//--------------------------------------------------------------

// CLASS IMPLEMENTATIONS--------------objc------------------------
//----------------------------------------------------------------
@implementation ofxiPhoneCoreLocationExtraDelegate

//--------------------------------------------------------------
//create getter/setter functions for these variables
@synthesize lat, lng, hAccuracy, alt, vAccuracy, distMoved, x, y, z, magneticHeading, trueHeading, headingAccuracy, gpsSpeed, locationRecorded, cumulatedDistance;

//--------------------------------------------------------------
- (id) init
{
	if(self = [super init])
	{		
		
		lat = 0;
		lng = 0;
		hAccuracy = 0;
		alt = 0;
		vAccuracy = 0;
		distMoved = 0;
        gpsSpeed = 0;
		locationRecorded = false;
        cumulatedDistance = 0;
        //timePassed = 0;
		
		x = 0;
		y = 0;
		z = 0;
		magneticHeading = 0;
		trueHeading = 0;
		headingAccuracy = 0;
		
		
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
	}
	return self;
}

//--------------------------------------------------------------
- (void)dealloc 
{ 
	[locationManager release];
	
	[super dealloc];
}

//--------------------------------------------------------------

- (bool) startHeading
{
	if([locationManager headingAvailable])
	{
		[locationManager startUpdatingHeading];
		return true;
	}
	else
		return false;
}

//--------------------------------------------------------------

- (void) stopHeading
{
	[locationManager stopUpdatingHeading];
}

//--------------------------------------------------------------

- (bool) startLocation
{
	if([locationManager locationServicesEnabled])
	{
		[locationManager startUpdatingLocation];
		return true;
	}
	else
		return false;
	
}

//--------------------------------------------------------------

- (void) stopLocation
{
	[locationManager stopUpdatingLocation];
}

- (void) resetCumulatedDistance
{
	cumulatedDistance = 0;
}

//--------------------------------------------------------------

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	if (signbit(newLocation.horizontalAccuracy)) {
		// Negative accuracy means an invalid or unavailable measurement
		NSLog(@"LatLongUnavailable");
	} else {
        
        // check if oldlocation is caching.
        if ([newLocation.timestamp timeIntervalSinceNow] > -10.0) // The value is not older than 10 sec. 
        { 
            // do something
            lat = newLocation.coordinate.latitude;
            lng = newLocation.coordinate.longitude;
            hAccuracy = newLocation.horizontalAccuracy;
            gpsSpeed = newLocation.speed;
            
            // double check if oldlocation is caching.
            if (oldLocation != nil) {
                
                /*
                 //timePassed = oldLocation.timestamp; 
                 NSDate* eventDate = newLocation.timestamp; 
                 NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
                 timePassed = howRecent;
                 */
                
                //CLLocationDistance distanceMoved = [newLocation getDistanceFrom:oldLocation]; // deprecated???
                CLLocationDistance distanceMoved = [newLocation distanceFromLocation:oldLocation];
                distMoved = distanceMoved;
                cumulatedDistance += distMoved;
                locationRecorded = true;
                
                
            }
        }
        else
        {
            NSLog(@"Cached data");
        }
		
	}

	if (signbit(newLocation.verticalAccuracy)) {
		// Negative accuracy means an invalid or unavailable measurement
		NSLog(@"AltUnavailable");
	} else {
		vAccuracy = newLocation.verticalAccuracy;
		alt = newLocation.altitude;
	}
	
}

//--------------------------------------------------------------

#ifdef __IPHONE_3_0
//called when the heading is updated
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
	x = newHeading.x;
	y = newHeading.y;
	z = newHeading.z;
	magneticHeading = newHeading.magneticHeading;
	trueHeading = newHeading.trueHeading;
	headingAccuracy = newHeading.headingAccuracy;
}
#endif

//--------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error //thx apple
{
	NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];
	
	if ([error domain] == kCLErrorDomain) {
		
		// We handle CoreLocation-related errors here
		
		switch ([error code]) {
				// This error code is usually returned whenever user taps "Don't Allow" in response to
				// being told your app wants to access the current location. Once this happens, you cannot
				// attempt to get the location again until the app has quit and relaunched.
				//
				// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
				// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
				//
			case kCLErrorDenied:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationDenied", nil)];
				break;
				
				// This error code is usually returned whenever the device has no data or WiFi connectivity,
				// or when the location cannot be determined for some other reason.
				//
				// CoreLocation will keep trying, so you can keep waiting, or prompt the user.
				//
			case kCLErrorLocationUnknown:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
				break;
				
				// We shouldn't ever get an unknown error code, but just in case...
				//
			default:
				[errorString appendFormat:@"%@ %d\n", NSLocalizedString(@"GenericLocationError", nil), [error code]];
				break;
		}
	} else {
		// We handle all non-CoreLocation errors here
		// (we depend on localizedDescription for localization)
		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
		[errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
	}
	
	// Send the update to our delegate
	NSLog(@"%@", errorString);
}

@end