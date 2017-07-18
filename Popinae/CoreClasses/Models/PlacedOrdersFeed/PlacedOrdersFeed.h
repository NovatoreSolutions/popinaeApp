//
//  PlacedOrdersFeed.h
//  Popinae
//
//  Created by Jamshaid on 08/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseFeed.h"
#import "BaseModel.h"

typedef void(^PlacedOrdersIdsCompletionHandler) (NSError* error,NSArray* ids);
typedef void(^PlacedOrdersListCompletionHandler) (NSError* error,NSArray* placedOrders);

@interface PlacedOrdersFeed : BaseFeed

+(PlacedOrdersFeed*)sharedPlacedOrdersFeed;

-(void)getListOfPlacedOrderIdsWithToken:(NSString*)token
                      completionHandler:(PlacedOrdersIdsCompletionHandler)handler;

-(void)getPlacedOrdersListWithToken:(NSString*)token
                     placedOrderIds:(NSArray*)orderIds
                  completionHandler:(PlacedOrdersListCompletionHandler)handler;

+(NSArray*)dummyPlacedOrders;

@end

@interface PlacedOrder : BaseModel

@property (strong,nonatomic) NSString* placedOrderId;
@property (readonly,strong,nonatomic) NSString* placedOrderClientId;
@property (strong,nonatomic) NSString* placedOrderStoreId;
@property (readonly,strong,nonatomic) NSString* placedOrderDate;
@property (readonly,strong,nonatomic) NSString* placedOrderIsPending; // "0" OR "1"
@property (readonly,strong,nonatomic) NSString* placedOrderIsPaid; // "0" OR "1"
@property (readonly,strong,nonatomic) NSString* placedOrderScheduleDate;
@property (readonly,strong,nonatomic) NSString* placedOrderDeliveryDate;
@property (strong,nonatomic) NSString* placedOrderTotalPrice;
@property (readonly,strong,nonatomic) NSString* placedOrderComments;
@property (readonly,strong,nonatomic) NSString* placedOrderStatusId; // "0" OR "1"
@property (readonly,strong,nonatomic) NSString* placedOrderStoreName;
@property (readonly,strong,nonatomic) NSString* placedOrderCurrencyId;
@property (readonly,strong,nonatomic) NSString* placedOrderCurrencyCode;
@property (readonly,strong,nonatomic) NSString* placedOrderCurrencyTitle;
@property (readonly,strong,nonatomic) NSString* placedOrderCurrencySymbol;
@property (readonly,strong,nonatomic) NSString* placedOrderClientName;
@property (strong,nonatomic) NSString* placedOrderStatusTitle;

@property (strong,nonatomic) NSMutableArray* placedOrderMeals;

-(void)populateData:(NSDictionary *)dataDict;

@end
