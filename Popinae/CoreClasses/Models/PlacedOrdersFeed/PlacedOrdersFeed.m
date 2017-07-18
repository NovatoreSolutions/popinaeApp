//
//  PlacedOrdersFeed.m
//  Popinae
//
//  Created by Jamshaid on 08/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "PlacedOrdersFeed.h"
#import "Utility.h"
#import "Constant.h"
#import "MealFeed.h"
#import "NSDictionary+ObjectWithKey.h"
#import "NSMutableDictionary+SetObjectWithKey.h"
#import "BaseFetcher.h"
#import "BaseParser.h"


@interface PlacedOrdersFeed()

@property (strong,nonatomic) NSMutableArray* placedOrders;

@end

static PlacedOrdersFeed* _sharedInstance = nil;

@implementation PlacedOrdersFeed

+(PlacedOrdersFeed *)sharedPlacedOrdersFeed{
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ _sharedInstance = [[PlacedOrdersFeed alloc]initSharedInstance];});
    return _sharedInstance;
}
-(id)initSharedInstance{
    
    self = [super init];
    if (self)
    {
        _placedOrders = [[NSMutableArray alloc]init];
    }
    return self;
}
-(id)init{
    
    NSAssert(_sharedInstance == nil,ERROR_SINGLETON);
    NSAssert(_sharedInstance != nil,ERROR_SINGLETON);
    return nil;
}

-(void)getListOfPlacedOrderIdsWithToken:(NSString*)token
                      completionHandler:(PlacedOrdersIdsCompletionHandler)handler{
    
    NSString* stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kPlacedOrdersListURL];
    
    NSDictionary* httpBody = @{kPlacedOrderTokenParam:token};
    
    BaseFetcher* fetcher = [[BaseFetcher alloc]init];
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_GET HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        
        if (error == nil) {
            BaseParser* parser = [[BaseParser alloc]init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
                if (error == nil) {
                    NSDictionary* dataDict = (NSDictionary*)dataObject;
                    NSArray* orders = (NSArray*)[dataDict objectForKey:kPlacedOrderRecordsKey];
                    NSMutableArray* orderIds = [[NSMutableArray alloc]init];
                    for (int i = 0; i < orders.count; i++) {
                        NSDictionary* order = (NSDictionary*)orders[i];
                        NSString* orderId = (NSString*)[order objectForKey:kPlacedOrderId];
                        [orderIds addObject:orderId];
                    }
                    handler(nil,orderIds); // success
                }else{
                    handler(error,nil); // parser error
                }
                
            }];
        }
        else{
            handler(error,nil); // fetcher error
        }
    }];
}

-(void)getPlacedOrdersListWithToken:(NSString*)token
                     placedOrderIds:(NSArray*)orderIds
                  completionHandler:(PlacedOrdersListCompletionHandler)handler{
    
}

+(NSArray*)dummyPlacedOrders{
    
    NSMutableArray* dummyOrders = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 5; i++) {
        PlacedOrder* order = [[PlacedOrder alloc]init];
        order.placedOrderId = [NSString stringWithFormat:@"%i",i];
        order.placedOrderStoreId = [NSString stringWithFormat:@"%i",i];
        order.placedOrderTotalPrice = @"$85.00";
        order.placedOrderStatusTitle = @"Accepted.In Processing...";
        Meal* meal1 = [[Meal alloc]init];
        meal1.mealTitle = @"Salmon with Vegetables";
        meal1.mealPrice = @"$36.00";
        Meal* meal2 = [[Meal alloc]init];
        meal2.mealTitle = @"Fried Chicken with Rice";
        meal2.mealPrice = @"$15.00";
        Meal* meal3 = [[Meal alloc]init];
        meal3.mealTitle = @"Mushrooms on Olive Oil";
        meal3.mealPrice = @"$22.00";
        Meal* meal4 = [[Meal alloc]init];
        meal4.mealTitle = @"Black Tagliatelli";
        meal4.mealPrice = @"$11.00";
        
        order.placedOrderMeals = [[NSMutableArray alloc]init];
        
        [order.placedOrderMeals addObject:meal1];
        [order.placedOrderMeals addObject:meal2];
        [order.placedOrderMeals addObject:meal3];
        [order.placedOrderMeals addObject:meal4];
        
        [dummyOrders addObject:order];
    }
    
    return dummyOrders;
}

@end


@implementation PlacedOrder

-(void)populateData:(NSDictionary *)dataDict{
    
    _placedOrderId             = [dataDict objectWithKey:kPlacedOrderId];
    _placedOrderClientId       = [dataDict objectWithKey:kPlacedOrderClientId];
    _placedOrderStoreId        = [dataDict objectWithKey:kPlacedOrderStoreId];
    _placedOrderDate           = [dataDict objectWithKey:kPlacedOrderDate];
    _placedOrderIsPending      = [dataDict objectWithKey:kPlacedOrderIsPending];
    _placedOrderIsPaid         = [dataDict objectWithKey:kPlacedOrderIsPaid];
    _placedOrderScheduleDate   = [dataDict objectWithKey:kPlacedOrderScheduleDate];
    _placedOrderDeliveryDate   = [dataDict objectWithKey:kPlacedOrderDeliveryDate];
    _placedOrderTotalPrice     = [dataDict objectWithKey:kPlacedOrderTotalPrice];
    _placedOrderComments       = [dataDict objectWithKey:kPlacedOrderComments];
    _placedOrderStatusId       = [dataDict objectWithKey:kPlacedOrderStatusId];
    _placedOrderStoreName      = [dataDict objectWithKey:kPlacedOrderStoreName];
    _placedOrderCurrencyId     = [dataDict objectWithKey:kPlacedOrderCurrencyId];
    _placedOrderCurrencyCode   = [dataDict objectWithKey:kPlacedOrderCurrencyCode];
    _placedOrderCurrencyTitle  = [dataDict objectWithKey:kPlacedOrderCurrencyTitle];
    _placedOrderCurrencySymbol = [dataDict objectWithKey:kPlacedOrderCurrencySymbol];
    _placedOrderClientName     = [dataDict objectWithKey:kPlacedOrderClientName];
    _placedOrderStatusTitle    = [dataDict objectWithKey:kPlacedOrderStatusTitle];

    // adding order meals
    _placedOrderMeals = [[NSMutableArray alloc]init];
    NSArray* meals = [dataDict objectWithKey:kPlacedOrderMeals];
    for (int i = 0; i < meals.count; i++) {
        NSDictionary* mealDict = (NSDictionary*)meals[i];
        if (mealDict) {
            Meal* meal = [[Meal alloc]init];
            [meal populateData:mealDict];
            [_placedOrderMeals addObject:meal];
        }
    }
}

-(NSString*)description{
    NSString* description = [NSString stringWithFormat:@"\n id = %@ \n client id = %@ \n store id = %@ \n date = %@ \n is pending = %@ \n is paid = %@ \n schedule = %@ \n delivery = %@ \n total price = %@ \n comments = %@ \n status id = %@ \n store name = %@ \n currency id = %@ \n currency code = %@ \n currency title = %@ \n currency symbol = %@ \n client name = %@ \n status title = %@ \n meals = %@",_placedOrderId,_placedOrderClientId,_placedOrderStoreId,_placedOrderDate,_placedOrderIsPending,_placedOrderIsPaid,_placedOrderScheduleDate,_placedOrderDeliveryDate,_placedOrderTotalPrice,_placedOrderComments,_placedOrderStatusId,_placedOrderStoreName,_placedOrderCurrencyId,_placedOrderCurrencyCode,_placedOrderCurrencyTitle,_placedOrderCurrencySymbol,_placedOrderClientName,_placedOrderStatusTitle,_placedOrderMeals.description];
    return description;
}


@end

























