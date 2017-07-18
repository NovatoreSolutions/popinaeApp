//
//  RestaurantFeed.h
//  Popinae
//
//  Created by AMK on 01/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"
#import "BaseFeed.h"

#import <MapKit/MapKit.h>

typedef void(^GetRestaurantsCompletionHandler) (NSError *error);

@interface Restaurant : BaseModel

@property(readonly,nonatomic,strong)NSString *storeId;
@property(readonly,nonatomic,strong)NSString *companyId;
@property(readonly,nonatomic,strong)NSString *storeName;
@property(readonly,nonatomic,strong)NSString *storeAddress;
@property(readonly,nonatomic,strong)NSString *storeLocation;
@property(readonly,nonatomic,strong)NSString *storePostalCode;
@property(readonly,nonatomic,strong)NSString *storeCity;
@property(readonly,nonatomic,strong)NSString *storeState;
@property(readonly,nonatomic,strong)NSString *storeCountry;
@property(readonly,nonatomic,strong)NSString *storeLat;
@property(readonly,nonatomic,strong)NSString *storeLng;
@property(readonly,nonatomic,strong)NSString *currencyId;
@property(readonly,nonatomic,strong)NSString *storePhone;
@property(readonly,nonatomic,strong)NSString *storeImage;
@property(readonly,nonatomic)double storeDistance;

-(void)populateData:(NSDictionary *)dataDict;


@end


@interface RestaurantFeed : BaseFeed

@property (readonly,strong,nonatomic) NSString *totalCount;
@property (readonly,strong,nonatomic) NSString *totalPages;
@property (readonly,strong,nonatomic) NSString *previousPageURLString;
@property (readonly,strong,nonatomic) NSString *nextPageURLString;
@property (readonly,strong,nonatomic) NSMutableArray *restaurantFeed;


- (Restaurant*)restaurantAtIndex:(NSInteger)index;
- (NSInteger)restaurantsCount;
- (void)removeAllRestaurants;
- (void)getRestaurantsWithKeyword:(NSString *)keyword
                   storeId:(NSNumber *)storeId
                      sortBy:(NSString *)sortBy
                     sortOrder:(NSString*)sortOrder
                      pageNo:(NSNumber *)pageNo
                   recordsNo:(NSNumber *)recordsNo
           completionHandler:(GetRestaurantsCompletionHandler)handler;

+(RestaurantFeed *)sharedRestaurantFeed;
-(MKCoordinateRegion)calculateRegion;
@end