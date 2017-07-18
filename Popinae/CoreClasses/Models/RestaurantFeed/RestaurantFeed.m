//
//  RestaurantFeed.m
//  Popinae
//
//  Created by AMK on 01/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "RestaurantFeed.h"
#import "BaseFetcher.h"
#import "BaseParser.h"
#import "NSDictionary+ObjectWithKey.h"
#import "Constant.h"
#import "NSMutableDictionary+SetObjectWithKey.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
#import "Utility.h"

@interface RestaurantFeed()<LocationManagerDelegate>

@property(nonatomic,strong)UserLocation *userLocation;

@end

static RestaurantFeed *_sharedInstance=nil;

@implementation RestaurantFeed


+(RestaurantFeed *)sharedRestaurantFeed
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ _sharedInstance = [[RestaurantFeed alloc]initSharedInstance];});
    return _sharedInstance;
}

-(id)initSharedInstance{
    
    self = [super init];
    if (self)
    {
        // custom initialization code
        _restaurantFeed =[[NSMutableArray alloc] init];
    }
    return self;
}

-(id)init{
    
    NSAssert(_sharedInstance == nil,ERROR_SINGLETON);
    NSAssert(_sharedInstance != nil,ERROR_SINGLETON);
    return nil;
}



-(void)populateData:(id)data withServerMessage:(NSString*)serverMessage {
    
    NSArray *serverArr = (NSArray*)[data objectWithKey:kRecords];
    
    _restaurantFeed=[[NSMutableArray alloc] initWithCapacity:serverArr.count];
    
    self.message = serverMessage;
    
    _totalCount = (NSString*) [data objectWithKey:kTotalCount];
    _totalPages = (NSString*) [data objectWithKey:kTotalPages];
    _previousPageURLString = (NSString*) [data objectWithKey:kPreviousPageURL];
    _nextPageURLString = (NSString*) [data objectWithKey:kNextPageURL];
    
    for (int i = 0; i<serverArr.count; i++) {
        
        Restaurant *restaurant = [[Restaurant alloc] init];
        
        NSDictionary *singleRestaurant   = (NSDictionary*)[serverArr objectAtIndex:i];
        
        [restaurant populateData:singleRestaurant];
        
        [_restaurantFeed addObject:restaurant];
    }
    
}

- (void)getRestaurantsWithKeyword:(NSString *)keyword
                          storeId:(NSNumber *)storeId
                           sortBy:(NSString *)sortBy
                        sortOrder:(NSString*)sortOrder
                           pageNo:(NSNumber *)pageNo
                        recordsNo:(NSNumber *)recordsNo
                completionHandler:(GetRestaurantsCompletionHandler)handler{
    
    
    
    NSString *stringURL  = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kRestaurants];
   
    
    NSMutableDictionary *httpBody = [[NSMutableDictionary alloc]init];
    
    [httpBody setObject:keyword WithKey:kkeyword];
    [httpBody setObject:storeId WithKey:kstoreId];
    [httpBody setObject:sortBy WithKey:ksortBy];
    [httpBody setObject:sortOrder WithKey:ksortOrder];
    [httpBody setObject:pageNo WithKey:kpageNo];
    [httpBody setObject:recordsNo WithKey:krecordsNo];
    
    
    BaseFetcher *fetcher = [[BaseFetcher alloc] init];
    
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_GET HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        
        if (error == nil) {
            
            BaseParser *parser = [[BaseParser alloc] init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
                
                if (error == nil) {
                    
                    [self populateData:dataObject withServerMessage:serverMsg];
                    
                }
                handler (error);
            }];
            
        }else{
            handler (error);
        }
    }];
    
}

-(Restaurant*)restaurantAtIndex:(NSInteger)index {
    if (index < [self restaurantsCount]) {
        return _restaurantFeed[index];
    }
    
    return nil;
}



- (NSInteger)restaurantsCount {
    return _restaurantFeed.count;
}


- (void)removeAllRestaurants{
    [_restaurantFeed removeAllObjects];

}

-(MKCoordinateRegion)calculateRegion {
    
    MKCoordinateRegion viewRegion;
    
    
    if(_restaurantFeed.count >0){
        
        
        
        Restaurant *temp = [_restaurantFeed objectAtIndex:0];
        double maxLat = [temp.storeLat doubleValue];
        double minLat = [temp.storeLat doubleValue];
        double maxLon = [temp.storeLng doubleValue];
        double minLon = [temp.storeLng doubleValue];
        
        for(int i = 0; i < [_restaurantFeed count]; i++) {
            //if([[locations objectAtIndex:i] isKindOfClass:[Location class]]) {
            Restaurant *loc = [_restaurantFeed objectAtIndex:i];
            double lat = [loc.storeLat doubleValue];
            double lon = [loc.storeLng doubleValue];
            if(lat > maxLat){
                maxLat = lat;
            } else if(lat < minLat) {
                minLat = lat;
            }
            if(lon > maxLon){
                maxLon = lon;
            } else if(lon < minLon) {
                minLon = lon;
            }
            //}
        }
        
        // FIND REGION
        MKCoordinateSpan locationSpan;
        locationSpan.latitudeDelta = maxLat - minLat;
        locationSpan.longitudeDelta = maxLon - minLon;
        
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat)/2, (minLon + maxLon)/2);
        viewRegion = MKCoordinateRegionMake(center, locationSpan);
        
    }
    /*
     MKMapRect zoomRect = MKMapRectNull;
     for(int i = 0; i < [locations count]; i++)
     {
     Location *loc = [locations objectAtIndex:i];
     //if([[locations objectAtIndex:i] isKindOfClass:[Location class]]) {
     MKMapPoint annotationPoint = MKMapPointForCoordinate(loc.coordinate);
     MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
     if (MKMapRectIsNull(zoomRect)) {
     zoomRect = pointRect;
     } else {
     zoomRect = MKMapRectUnion(zoomRect, pointRect);
     }
     //}
     }
     
     return zoomRect;*/
    
    return viewRegion;
    
    
}




#pragma - mark
#pragma - location manager delegate methods

-(void)getRecentLocationReturnsWithLocation:(UserLocation *)location andErrorMessage:(NSString *)errorMsg{
    if (location) {
        _userLocation = location;
        
    }else{
        [Utility showAlertWithTitle:@"Location error" message:errorMsg];
    }
}



@end

@implementation Restaurant

-(void)populateData:(NSDictionary *)dataDict{
    
    // pay attention that this function  is "objectWithKey" not "objectForKey"
    _storeId = [dataDict objectWithKey:kstoreId];
    _companyId = [dataDict objectWithKey:kcompanyId];
    _storeName=[dataDict objectWithKey:kstoreName];
    _storeAddress=[dataDict objectWithKey:kstoreAddress];
    _storeLocation = [dataDict objectWithKey:kstoreLocation];
    _storePostalCode=[dataDict objectWithKey:kstorePostalCode];
    _storeCity=[dataDict objectWithKey:kstoreCity];
    _storeState=[dataDict objectWithKey:kstoreState];
    _storeCountry=[dataDict objectWithKey:kstoreCountry];
    _storeLat=[dataDict objectWithKey:kstoreLat];
    _storeLng=[dataDict objectWithKey:kstoreLng];
    _currencyId=[dataDict objectWithKey:kcurrencyId];
    _storePhone=[dataDict objectWithKey:kstorePhone];
    _storeImage=[dataDict objectWithKey:kstoreImage];
    
    LocationManager *manager=[LocationManager sharedManager];
    
    CLLocation *currentLocation=[[CLLocation alloc]initWithLatitude:manager.lastUpdatedUserLocation.userLocationLatitude longitude:manager.lastUpdatedUserLocation.userLocationLongitude];
    
    CLLocation *givenLocation=[[CLLocation alloc]initWithLatitude:[_storeLat floatValue] longitude:[_storeLng floatValue]];
    
    _storeDistance = [self calculateDistanceFromCurrentLocation:currentLocation fromGivenLocation:givenLocation]/1000;


    
    
}


-(CLLocationDistance)calculateDistanceFromCurrentLocation:(CLLocation *)currentLocation fromGivenLocation:(CLLocation *)givenLocation

{
    CLLocationDistance distance=0.0;

    distance = [currentLocation distanceFromLocation:givenLocation];
        

    return distance;
    
    
}




@end
