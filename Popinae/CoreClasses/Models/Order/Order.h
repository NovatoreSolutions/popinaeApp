//
//  Order.h
//  Popinae
//
//  Created by Jamshaid on 30/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OrderState)
{
    OrderStateEmpty,
    OrderStateMealAdded,
    OrderStateMealDeleted,
    OrderStateNoChange
};

@class Meal;

@interface Order : NSObject

@property (strong,nonatomic) NSDate* orderDate;

+(Order*)sharedOrder;

-(void)addNewMealInOrder:(Meal*)meal;
-(void)removeThisMealFromOrder:(Meal*)meal;
-(void)refreshOrder;
-(Meal*)getMealAtIndex:(NSInteger)index;
-(Meal*)getLastMeal;

-(NSInteger)getNumberOfMealsInOrder;
-(float)getTheOrderTotal; // add up all the meal prices * meal quantities and returns it
-(BOOL)isThisMealAlreadyAdded:(Meal*)meal; // check the meal in selectedMeals return true/false

-(OrderState)orderState;

@end
