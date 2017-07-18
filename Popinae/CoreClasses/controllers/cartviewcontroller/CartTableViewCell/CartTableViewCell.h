//
//  orderTableViewCell.h
//  Popinae
//
//  Created by Jamshaid on 30/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealFeed.h"

@interface CartTableViewCell : UITableViewCell

-(void)populateDataWithMeal:(Meal*)meal;
-(Meal*)getStoredMeal;

@end
