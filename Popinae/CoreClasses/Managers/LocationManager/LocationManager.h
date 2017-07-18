//
//  LocationManager.h
//  LocationTeller-iOS
//
//  Created by Jamshaid on 23/11/2014.
//  Copyright (c) 2014 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class UserLocation;

/* information to be added in info.plist

 key: NSLocationAlwaysUsageDescription      value: Provide Reason to use location, shown to user by ios
 key: NSLocationWhenInUseUsageDescription   value: Provide Reason to use location, shown to user by ios
 

*/

// CONSTANTS

extern NSString* const MSG_LOCATION_ACCESS_DENIED; // user has denied the app request for location
extern NSString* const MSG_LOCATION_ACCESS_RESTRICTED; // user has restricted this apps access to location
extern NSString* const MSG_LOCATION_ACCESS_ALLOWED;// user has allowed the app request for location
extern NSString* const MSG_LOCATION_ACCESS_SOME_ERROR;// user has allowed but for some reason location fail

@protocol LocationManagerDelegate;

@interface LocationManager : NSObject
// delegate must be with weak...
@property (weak,nonatomic) id<LocationManagerDelegate>delegate;

/* this property gives location that is set when "getRecentLocation" method is last time called, to get most recent location call "getRecentLocation" and use value returned in delegate method */
@property (strong,nonatomic) UserLocation* lastUpdatedUserLocation;

+(LocationManager*)sharedManager;

/* controller should call this method and ask user to enable location service if no is returned by this method, user can enable/disable location services by togelling switch in setting app */
-(BOOL)isLocationServiceEnabled;

/* controller can call this method to get the most recent location according to timestamp */
-(void)getRecentLocation;

@end

@protocol LocationManagerDelegate <NSObject>

-(void)getRecentLocationReturnsWithLocation:(UserLocation*)location andErrorMessage:(NSString*)errorMsg;

@end

// north = 0 degrees, east = 90 degrees, south = 180 degrees

@interface UserLocation : NSObject

@property CLLocationDegrees userLocationLatitude; // represents latitude in degrees
@property CLLocationDegrees userLocationLongitude; // represents longitude in degress
@property CLLocationDistance userLocationAltitude; // +ve = above sea level, -ve = below sea level
@property (strong,nonatomic) NSDate* userLocationTimeStamp; // date/time at which location is measured
@property CLLocationSpeed userLocationSpeed; // represents speed of a moving device in meters/sec
@property CLLocationDirection userLocationDirection;
/* represents a direction that is measured in degrees relative to true north, negative value means invalid direction */

@end


