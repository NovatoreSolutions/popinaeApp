//
//  Order.m
//  Popinae
//
//  Created by Jamshaid on 30/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "Order.h"
#import "MealFeed.h"
#import "Constant.h"

@interface Order ()

@property (strong,nonatomic) NSMutableArray* selectedMeals;

@property (assign,nonatomic) NSInteger mealsCounter; // keeps track of changes in order

@end

static Order* _sharedInstance = nil;

@implementation Order

+(Order*)sharedOrder{
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ _sharedInstance = [[Order alloc]initSharedInstance];});
    return _sharedInstance;
}
-(id)initSharedInstance{
    
    self = [super init];
    if (self)
    {
        // custom initialization code
        self.selectedMeals = [[NSMutableArray alloc]init];
        // initialize the meals counter with selected meals count
        self.mealsCounter = self.selectedMeals.count;
    }
    return self;
}
-(id)init{
    
    NSAssert(_sharedInstance == nil,ERROR_SINGLETON);
    NSAssert(_sharedInstance != nil,ERROR_SINGLETON);
    return nil;
}
-(void)addNewMealInOrder:(Meal *)meal{
    [self.selectedMeals addObject:meal];
}
-(void)removeThisMealFromOrder:(Meal *)meal{
    NSInteger indexOfObject = [self.selectedMeals indexOfObject:meal];
    if (indexOfObject != NSNotFound) {
        [self.selectedMeals removeObject:meal];
    }
}
-(void)refreshOrder{
    [self.selectedMeals removeAllObjects];
    self.orderDate = nil;
}
-(Meal*)getMealAtIndex:(NSInteger)index{
    if (index >= 0 && index < self.selectedMeals.count) {
        return (Meal*)[self.selectedMeals objectAtIndex:index];
    }else{
        return nil;
    }
}
-(NSInteger)getNumberOfMealsInOrder{
    return self.selectedMeals.count;
}
-(float)getTheOrderTotal{
    float orderTotal = 0.00f;
    for (int i = 0; i < self.selectedMeals.count; i++) {
        Meal* currentMeal = (Meal*)self.selectedMeals[i];
        float currentMealPrice = [[currentMeal mealTotalPrice] floatValue];
        orderTotal = orderTotal + currentMealPrice;
    }
    return orderTotal;
}
-(BOOL)isThisMealAlreadyAdded:(Meal *)meal{
    if (meal == nil || self.selectedMeals.count == 0) {
        return NO;
    }
    BOOL isMealFound = NO;
    NSString* mealFamilyID = meal.mealFamilyId;
    NSString* mealID = meal.mealId;
    for (int i = 0; i < self.selectedMeals.count; i++) {
        Meal* currentMeal = (Meal*)self.selectedMeals[i];
        if ([currentMeal.mealFamilyId isEqualToString:mealFamilyID]) {
            if ([currentMeal.mealId isEqualToString:mealID]) {
                isMealFound = YES;
                break;
            }
        }
    }
    return isMealFound;
}
-(Meal*)getLastMeal{
    
   return (Meal*) self.selectedMeals.lastObject;
}

-(OrderState)orderState{
    
    OrderState orderState = OrderStateNoChange;
    
    if (self.selectedMeals.count == 0) {
        orderState = OrderStateEmpty;
    }
    else if (self.mealsCounter == self.selectedMeals.count) {
        orderState = OrderStateNoChange;
    }
    else if (self.mealsCounter < self.selectedMeals.count) {
        orderState = OrderStateMealAdded;
    }
    else if (self.mealsCounter > self.selectedMeals.count) {
        orderState = OrderStateMealDeleted;
    }
    
    // reset mealsCounter
    self.mealsCounter = self.selectedMeals.count;
    
    return orderState;
}


@end










