//
//  LocationManager.m
//  LocationTeller-iOS
//
//  Created by Jamshaid on 23/11/2014.
//  Copyright (c) 2014 iDevNerds. All rights reserved.
//

#import "LocationManager.h"

NSString* const MSG_LOCATION_ACCESS_DENIED = @"ACCESS TO LOCATION DATA IS DENIED";
NSString* const MSG_LOCATION_ACCESS_RESTRICTED = @"ACCESS TO LOCATION DATA IS RESTRICTED";
NSString* const MSG_LOCATION_ACCESS_ALLOWED = @"ACCESS TO LOCATION DATA IS ALLOWED";
NSString* const MSG_LOCATION_ACCESS_SOME_ERROR = @"LOCATION SERVICE IS FAILED FOR SOME REASON";

NSString* const ERROR_SINGLETON = @"THERE CAN ONLY BE ONE LOCATION MANAGER INSTANCE";

@interface LocationManager()<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager* manager;

@end

static LocationManager* _sharedInstance = nil;

@implementation LocationManager

+(LocationManager*)sharedManager
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ _sharedInstance = [[LocationManager alloc]initSharedInstance];});
    return _sharedInstance;
}
-(id)initSharedInstance
{
    self = [super init];
    if (self)
    {
        // custom initialization code
        self.manager = [[CLLocationManager alloc]init];
        self.manager.pausesLocationUpdatesAutomatically = YES;
        self.manager.distanceFilter = kCLDistanceFilterNone;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.delegate = self;
    }
    return self;
}
-(id)init
{
    NSAssert(_sharedInstance == nil,ERROR_SINGLETON);
    NSAssert(_sharedInstance != nil,ERROR_SINGLETON);
    return nil;
}
-(BOOL)isLocationServiceEnabled
{
    return [CLLocationManager locationServicesEnabled];
}
-(void)getRecentLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            [self askUserForLocationAccess];
            break;
        case kCLAuthorizationStatusAuthorizedAlways: // same value as kCLAuthorizationStatusAuthorized
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.manager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            if ([self.delegate respondsToSelector:@selector(getRecentLocationReturnsWithLocation:andErrorMessage:)])
            {
                [self.delegate getRecentLocationReturnsWithLocation:nil andErrorMessage:MSG_LOCATION_ACCESS_DENIED];
            }
            break;
        case kCLAuthorizationStatusRestricted:
            if ([self.delegate respondsToSelector:@selector(getRecentLocationReturnsWithLocation:andErrorMessage:)])
            {
                [self.delegate getRecentLocationReturnsWithLocation:nil andErrorMessage:MSG_LOCATION_ACCESS_RESTRICTED];
            }
            break;
        default:
            break;
    }
}
-(void)askUserForLocationAccess
{
    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        // ios 8+
        [self.manager requestAlwaysAuthorization];
    }
    else if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        // ios 8+
        [self.manager requestWhenInUseAuthorization];
    }
    else {
        // ios 7 and earlier
        [self.manager startUpdatingLocation];
    }
}

#pragma - mark
#pragma - CLLocationManagerDelegate - methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self getRecentLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // stop updates
    [self.manager stopUpdatingLocation];
     [manager stopMonitoringSignificantLocationChanges];
    
    CLLocation* mostRecentLocation = (CLLocation*)[locations lastObject];
    // create UserLocation object
    self.lastUpdatedUserLocation = [[UserLocation alloc]init];
    self.lastUpdatedUserLocation.userLocationLatitude  = mostRecentLocation.coordinate.latitude;
    self.lastUpdatedUserLocation.userLocationLongitude = mostRecentLocation.coordinate.longitude;
    self.lastUpdatedUserLocation.userLocationAltitude  = mostRecentLocation.altitude;
    self.lastUpdatedUserLocation.userLocationTimeStamp = mostRecentLocation.timestamp;
    self.lastUpdatedUserLocation.userLocationSpeed     = mostRecentLocation.speed;
    self.lastUpdatedUserLocation.userLocationDirection = mostRecentLocation.course;
    // inform delegate
    if ([self.delegate respondsToSelector:@selector(getRecentLocationReturnsWithLocation:andErrorMessage:)])
    {
        [self.delegate getRecentLocationReturnsWithLocation:self.lastUpdatedUserLocation andErrorMessage:MSG_LOCATION_ACCESS_ALLOWED];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // inform delegate
    if (error &&[self.delegate respondsToSelector:@selector(getRecentLocationReturnsWithLocation:andErrorMessage:)])
    {
        
        [self.delegate getRecentLocationReturnsWithLocation:nil andErrorMessage:MSG_LOCATION_ACCESS_SOME_ERROR];
    }
}

@end

@implementation UserLocation

-(NSString*)description
{
    return [NSString stringWithFormat:@"\nLatitude = %f \nLongitude = %f \nAltitude = %f \nTime Stamp = %@ \nSpeed = %f \nDirection = %f \n",self.userLocationLatitude,self.userLocationLongitude,self.userLocationAltitude,self.userLocationTimeStamp.description,self.userLocationSpeed,self.userLocationDirection];
}

@end

