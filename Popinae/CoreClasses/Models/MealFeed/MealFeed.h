//
//  MealsFeed.h
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "BaseFeed.h"

#import <MapKit/MapKit.h>

typedef void(^GetMealsCompletionHandler) (NSError *error);
typedef void(^GetMealsListCompletionHandler) (NSError *error);

@interface Meal : BaseModel

@property (readonly,strong,nonatomic) NSString *mealId;
@property (readonly,strong,nonatomic) NSString *mealDescription;

// temp making mealPrice & mealTitle not readonly becz dummy data in OrdersVC
@property (strong,nonatomic) NSString *mealPrice;
@property (strong,nonatomic) NSString *mealTitle;

@property (readonly,strong,nonatomic) NSString *mealImage;
@property (readonly,strong,nonatomic) NSString *mealFamilyId;
@property (readonly,strong,nonatomic) NSString *mealFamilyName;
@property (readonly,strong,nonatomic) NSString *currencyCode;
@property (readonly,strong,nonatomic) NSString *currencyID;
@property (readonly,strong,nonatomic) NSString *currencySymbol;
@property (readonly,strong,nonatomic) NSString *currencyTitle;
@property (readonly,strong,nonatomic) NSString *quantity;
@property (readonly,strong,nonatomic) NSString *storeID;
@property (readonly,strong,nonatomic) NSString *storeName;
@property (readonly,strong,nonatomic) NSString *storeLat;
@property (readonly,strong,nonatomic) NSString *storeLng;
@property (readonly,strong,nonatomic) NSString *distance;

-(void)populateData:(NSDictionary *)dataDict withValueI:(int) i;

-(void)populateData:(NSDictionary *)dataDict;

-(void)updateMealQuantity:(NSString*)quantity;

-(NSString*)mealTotalPrice; // returns mealPrice * mealQuantity

-(NSString*)mealsTitle;

@end

@interface MealFeed : BaseFeed

@property (readonly,strong,nonatomic) NSString *totalCount;
@property (readonly,strong,nonatomic) NSString *totalPages;
@property (readonly,strong,nonatomic) NSString *previousPageURLString;
@property (readonly,strong,nonatomic) NSString *nextPageURLString;
@property (readonly,strong,nonatomic) NSMutableArray *mealFeed;
@property (readonly,assign,nonatomic) BOOL isCurrentlyShowingNearbyMeals;
- (Meal*)mealAtIndex:(NSInteger)index;
- (NSInteger)mealsCount;
- (void)removeAllMeals;



- (void)getMealsWithLatitude:(NSNumber *)latitude
                   longitude:(NSNumber *)longitude
                      radius:(NSNumber *)radius
                     keyword:(NSString*)keyword
                      pageNo:(NSNumber *)pageNo
                   recordsNo:(NSNumber *)recordsNo
           completionHandler:(GetMealsCompletionHandler)handler;

- (void)getMealsWithMealId:(NSNumber*)mealId
              mealFamilyId:(NSNumber*)mealFamilyId
                   storeId:(NSNumber*)storeId
                    sortBy:(NSString*)sortBy
                 sortOrder:(NSString *)sortOrder
                    pageNo:(NSNumber*)pageNo
                 recordsNo:(NSNumber*)recordsNo
                      lang:(NSString *)lang
         completionHandler:(GetMealsListCompletionHandler)handler;

+(MealFeed *)sharedMealFeed;
-(MKCoordinateRegion)calculateRegion;

@end
