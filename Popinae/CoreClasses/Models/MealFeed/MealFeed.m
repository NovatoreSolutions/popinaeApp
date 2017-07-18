//
//  MealsFeed.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "MealFeed.h"
#import "BaseFetcher.h"
#import "BaseParser.h"
#import "NSDictionary+ObjectWithKey.h"
#import "NSMutableDictionary+SetObjectWithKey.h"
#import "Constant.h"


static MealFeed*_sharedInstance=nil;
@implementation MealFeed

+(MealFeed *)sharedMealFeed
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ _sharedInstance = [[MealFeed alloc]initSharedInstance];});
    return _sharedInstance;
}

-(id)initSharedInstance{
    
    self = [super init];
    if (self)
    {
        // custom initialization code
        _mealFeed =[[NSMutableArray alloc] init];
    }
    return self;
}

-(id)init{
    
    NSAssert(_sharedInstance == nil,ERROR_SINGLETON);
    NSAssert(_sharedInstance != nil,ERROR_SINGLETON);
    return nil;
}

-(void)populateData:(id)data withServerMessage:(NSString*)serverMessage {
  
    self.message = serverMessage;
    
    _totalCount = (NSString*) [data objectWithKey:kTotalCount];
    _totalPages = (NSString*) [data objectWithKey:kTotalPages];
    _previousPageURLString = (NSString*) [data objectWithKey:kPreviousPageURL];
    _nextPageURLString = (NSString*) [data objectWithKey:kNextPageURL];
    
    NSArray *serverArr = (NSArray*)[data objectWithKey:kRecords];
    
    for (int i = 0; i < serverArr.count; i++) {
        Meal *meal = [[Meal alloc] init];
        NSDictionary *singleMeal   = (NSDictionary*)[serverArr objectAtIndex:i];
        [meal populateData:singleMeal];
        [_mealFeed addObject:meal];
    }
}

- (void)getMealsWithLatitude:(NSNumber *)latitude
                    longitude:(NSNumber *)longitude
                       radius:(NSNumber *)radius
                      keyword:(NSString*)keyword
                       pageNo:(NSNumber *)pageNo
                    recordsNo:(NSNumber *)recordsNo
            completionHandler:(GetMealsCompletionHandler)handler{
    
        [self removeAllMeals];

#if DEBUG

    latitude = [NSNumber numberWithFloat:31.458122]   ; // to check meals returned against client location
    longitude = [NSNumber numberWithFloat:74.301905]; // to check meals returned against client location


#endif

    _isCurrentlyShowingNearbyMeals = YES;
  
    
    NSString *stringURL  = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kMealsNearby];
    
        
    NSMutableDictionary *httpBody = [[NSMutableDictionary alloc] init];
    
    [httpBody setObject:latitude WithKey:klat];
    [httpBody setObject:longitude WithKey:klng];
    [httpBody setObject:radius WithKey:kradius];
    [httpBody setObject:keyword WithKey:kkeyword];
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
            handler (error); // error in fetching
        }
    }];
}


- (void)getMealsWithMealId:(NSNumber*)mealId
                   mealFamilyId:(NSNumber*)mealFamilyId
                      storeId:(NSNumber*)storeId
                     sortBy:(NSString*)sortBy
                      sortOrder:(NSString *)sortOrder
                    pageNo:(NSNumber*)pageNo
                   recordsNo:(NSNumber*)recordsNo
                      lang:(NSString *)lang
           completionHandler:(GetMealsListCompletionHandler)handler{
    
    _isCurrentlyShowingNearbyMeals  =NO;
    [self removeAllMeals];
    
    NSString *stringURL  = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kMealsList];

    
    NSMutableDictionary *httpBody = [[NSMutableDictionary alloc] init];
    
    [httpBody setObject:mealId WithKey:kMealId];
    [httpBody setObject:mealFamilyId WithKey:kMealFamilyId];
    [httpBody setObject:storeId WithKey:kstoreId];
    [httpBody setObject:sortBy WithKey:ksortBy];
    [httpBody setObject:sortOrder WithKey:ksortOrder];
    [httpBody setObject:pageNo WithKey:kpageNo];
    [httpBody setObject:recordsNo WithKey:krecordsNo];
    [httpBody setObject:lang WithKey:kLanguage];
    

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

-(Meal*)mealAtIndex:(NSInteger)index {
    if (index < [self mealsCount]) {
        return (Meal*) _mealFeed[index];
    }
    
    return nil;
}

- (NSInteger)mealsCount {
    return _mealFeed.count;
}

- (void)removeAllMeals{
    [_mealFeed removeAllObjects];
    
    
}
-(MKCoordinateRegion)calculateRegion {
    
    MKCoordinateRegion viewRegion;
    
    
    if(_mealFeed.count >0){
        
    
    
        Meal *temp = [_mealFeed objectAtIndex:0];
        double maxLat = [temp.storeLat doubleValue];
        double minLat = [temp.storeLat doubleValue];
        double maxLon = [temp.storeLng doubleValue];
        double minLon = [temp.storeLng doubleValue];
        
        for(int i = 0; i < [_mealFeed count]; i++) {
            //if([[locations objectAtIndex:i] isKindOfClass:[Location class]]) {
            Meal *loc = [_mealFeed objectAtIndex:i];
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

@end


@implementation Meal

-(void)populateData:(NSDictionary *)dataDict {
    
    // pay attention that this function  is "objectWithKey" not "objectForKey"
    _mealId          = [dataDict objectWithKey:kMealId];
    _mealDescription = [dataDict objectWithKey:kMealDescription];
    _mealPrice       = [dataDict objectWithKey:kMealPrice];
    _mealTitle       = [dataDict objectWithKey:kMealTitle];
    _mealImage       = [dataDict objectWithKey:kMealImage];
    _mealFamilyId    = [dataDict objectWithKey:kMealFamilyId];
    _mealFamilyName  = [dataDict objectWithKey:kMealFamilyName];
    _currencyCode    = [dataDict objectWithKey:kMealCurrencyCode];
    _currencyID      = [dataDict objectWithKey:kMealCurrencyID];
    _currencySymbol  = [dataDict objectWithKey:kMealCurrencySymbol];
    _currencyTitle   = [dataDict objectWithKey:kMealCurrencyTitle];
    _storeID         = [dataDict objectWithKey:kMealStoreId];
    _storeName       = [dataDict objectWithKey:kMealStoreName];
    _storeLat        = [dataDict objectWithKey:kMealStoreLat];
    _storeLng        = [dataDict objectWithKey:kMealStoreLng];
    _distance        = [dataDict objectWithKey:kMealDistance];
    _quantity        = [dataDict objectWithKey:kMealQuantity];
}

-(NSString*)description{
    NSString* description = [NSString stringWithFormat:@"\n meal id = %@ \n meal description = %@ \n meal price = %@ \n meal title = %@ \n meal image = %@ \n meal family id = %@ \n meal family name = %@ \n meal currency code = %@ \n meal currency id = %@ \n meal currency symbol = %@ \n meal currency title = %@ \n meal store id = %@ \n meal store name = %@ \n meal store lat = %@ \n meal store lng = %@ \n meal distance = %@ \n meal quantity = %@",_mealId,_mealDescription,_mealPrice,_mealTitle,_mealImage,_mealFamilyId,_mealFamilyName,_currencyCode,_currencyID,_currencySymbol,_currencyTitle,_storeID,_storeName,_storeLat,_storeLng,_distance,_quantity];
    return description;
}

-(void)populateData:(NSDictionary *)dataDict withValueI:(int) i {
    
    // pay attention that this function  is "objectWithKey" not "objectForKey"
    _mealId          = [dataDict objectWithKey:kMealId];
    _mealDescription = [dataDict objectWithKey:kMealDescription];
    _mealPrice       = [dataDict objectWithKey:kMealPrice];
    _mealTitle       = [dataDict objectWithKey:kMealTitle];
    _mealImage       = [dataDict objectWithKey:kMealImage];
    _mealFamilyId    = [dataDict objectWithKey:kMealFamilyId];
    _mealFamilyName  = [dataDict objectWithKey:kMealFamilyName];
    _currencyCode    = [dataDict objectWithKey:kMealCurrencyCode];
    _currencyID      = [dataDict objectWithKey:kMealCurrencyID];
    _currencySymbol  = [dataDict objectWithKey:kMealCurrencySymbol];
    _currencyTitle   = [dataDict objectWithKey:kMealCurrencyTitle];
    _storeID         = [dataDict objectWithKey:kMealStoreId];
    _storeName       = [dataDict objectWithKey:kMealStoreName];
    _storeLat        = [dataDict objectWithKey:kMealStoreLat];
    
    double value =  _storeLat.doubleValue;
    value = value + i;
    
    _storeLat = [NSString stringWithFormat:@"%f",value];
    
    _storeLng=[dataDict objectWithKey:kMealStoreLng];
    
     value =  _storeLng.doubleValue;
    value = value + i;
    
    _storeLng = [NSString stringWithFormat:@"%f",value];
    
    _distance=[dataDict objectWithKey:kMealDistance];
}

-(void)updateMealQuantity:(NSString*)quantity{
    _quantity = quantity;
}
-(NSString*)mealTotalPrice{
    NSInteger mealQuantity = [_quantity integerValue];
    NSInteger mealPrice = [_mealPrice integerValue];
    NSInteger mealPriceTimesQuantity = mealPrice * mealQuantity;
    return [NSString stringWithFormat:@"%ld",(long)mealPriceTimesQuantity];
}
-(NSString*)mealsTitle{
    return [NSString stringWithString:_mealTitle];
}

@end















