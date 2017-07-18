//
//  Cart.h
//  Popinae
//
//  Created by Jamshaid on 03/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseModel.h"

@class Meal;

typedef void(^AddMealCompletionHandler) (NSError* error);
typedef void(^RemoveMealCompletionHandler) (NSError* error);
typedef void(^EmptyCartCompletionHandler) (NSError* error);
typedef void(^ViewCartCompletionHandler) (NSError* error,NSArray* meals);
typedef void(^CheckoutCompletionHandler) (NSError* error);

@interface Cart : BaseModel

+(void)addMealToCartWithToken:(NSString*)token
                       mealID:(NSString*)mealID
                 mealQuantity:(NSString*)quantity
            completionHandler:(AddMealCompletionHandler)handler;

+(void)removeMealFromCartWithToken:(NSString*)token
                            mealID:(NSString*)mealID
                 completionHandler:(RemoveMealCompletionHandler)handler;

+(void)emptyCartWithMeals:(NSArray*)meals
                withToken:(NSString*)token
        completionHandler:(EmptyCartCompletionHandler)handler;

+(void)viewCartWithToken:(NSString*)token
       completionHandler:(ViewCartCompletionHandler)handler;

+(void)checkoutWithToken:(NSString*)token
            deliveryDate:(NSDate*)date
                comments:(NSString*)comments
       completionHandler:(CheckoutCompletionHandler)handler;

@end
