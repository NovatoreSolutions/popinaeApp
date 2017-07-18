//
//  Cart.m
//  Popinae
//
//  Created by Jamshaid on 03/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "Cart.h"
#import "MealFeed.h"
#import "BaseFetcher.h"
#import "BaseParser.h"
#import "Constant.h"
#import "NSDictionary+ObjectWithKey.h"

@implementation Cart

+(void)addMealToCartWithToken:(NSString*)token
                       mealID:(NSString*)mealID
                 mealQuantity:(NSString*)quantity
            completionHandler:(AddMealCompletionHandler)handler{
    
    if (quantity == nil) {
        quantity = @"1"; // setting default value for quantity
    }
    
    NSString* stringURL = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kUpdateCartURL];
    
    NSDictionary* httpBody = nil;
    httpBody = @{kCartTokenParam:token,kCartMealIDParam:mealID,kCartQuantityParam:quantity};
    
    BaseFetcher* fetcher = [[BaseFetcher alloc]init];
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_GET HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        
        if (error == nil) {
            BaseParser* parser = [[BaseParser alloc]init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
                
               // no need to populate data
                handler(error); // informing caller about success
            }];
        }else{
            handler(error); // informing caller about failure
        }
    }];
}

+(void)removeMealFromCartWithToken:(NSString*)token
                            mealID:(NSString*)mealID
                 completionHandler:(RemoveMealCompletionHandler)handler{
    
    NSString* stringURL = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kUpdateCartURL];
    
    NSString* quantity = @"0"; // to indicate the removal of this meal from cart
    
    NSDictionary* httpBody = nil;
    httpBody = @{kCartTokenParam:token,kCartMealIDParam:mealID,kCartQuantityParam:quantity};
    
    BaseFetcher* fetcher = [[BaseFetcher alloc]init];
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_GET HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        
        if (error == nil) {
            BaseParser* parser = [[BaseParser alloc]init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
    
                // no need to populate data
                handler(error); // informing caller about success
            }];
        }else{
            handler(error); // informing caller about failure
        }
    }];
}

+(void)viewCartWithToken:(NSString*)token
       completionHandler:(ViewCartCompletionHandler)handler{
    
    NSString* stringURL = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kViewCartURL];
    
    NSDictionary* httpBody = nil;
    httpBody = @{kCartTokenParam:token};

    BaseFetcher* fetcher = [[BaseFetcher alloc]init];
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_GET HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        
        if (error == nil) {
            BaseParser* parser = [[BaseParser alloc]init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
        
                NSArray* meals = [Cart createMealsFromCart:dataObject];
                handler(error,meals); // informing caller about success and providing meals in cart
            }];
        }else{
            handler(error,nil); // informing caller about failure
        }
    }];
}

+(void)emptyCartWithMeals:(NSArray*)meals
                withToken:(NSString*)token
        completionHandler:(EmptyCartCompletionHandler)handler{
    
    Meal* meal = (Meal*)[meals lastObject]; // pick meal from cart to remove
    
    NSString* stringURL = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kUpdateCartURL];
    
    NSString* quantity = @"0"; // to indicate the removal of this meal from cart
    
    NSDictionary* httpBody = nil;
    httpBody = @{kCartTokenParam:token,kCartMealIDParam:meal.mealId,kCartQuantityParam:quantity};

    BaseFetcher* fetcher = [[BaseFetcher alloc]init];
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_GET HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        
        if (!error) {
            BaseParser* parser = [[BaseParser alloc]init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
                if (!error) {
                    
                    NSArray* remainingMeals = [Cart createMealsFromCart:dataObject];
                    if (remainingMeals.count == 0) { // base case, true when cart becomes empty
                        handler(error);
                    }else{
                        [Cart emptyCartWithMeals:remainingMeals withToken:token completionHandler:nil];
                    }
                    
                }else{
                    
                    handler(error);
                }
           }];//parse
        }// if
    }];// fetcher
    
}

#pragma - mark
#pragma - helper methods

+(NSArray*)createMealsFromCart:(id)dataObject{
    NSMutableArray* meals = [[NSMutableArray alloc]init];
    
    NSDictionary* dataDict = (NSDictionary*)dataObject;
    NSDictionary* cartDict = (NSDictionary*)[dataDict objectWithKey:@"cartData"];
    NSArray* stores = (NSArray*)[cartDict objectWithKey:@"_stores"];
    
    for (int i = 0; i < stores.count; i++) {
        NSDictionary* storeDict = (NSDictionary*)stores[i];
        NSArray* storeMeals = (NSArray*)[storeDict objectWithKey:@"_meals"];
        for (int j = 0; j < storeMeals.count; j++) {
            NSDictionary* mealDict = (NSDictionary*)storeMeals[j];
            Meal* meal = [[Meal alloc]init];
//            [meal populateDataWithStore:storeDict andMeal:mealDict];
//            [meals addObject:meal];
        }
    }// for
    
    return meals;
}

@end



















