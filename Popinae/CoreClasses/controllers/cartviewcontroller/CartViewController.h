//
//  OrderViewController.h
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseViewController.h"
#import "MealFeed.h"

@interface CartViewController : BaseViewController

/* when order button is pressed in MealsViewController OR MealDetailViewController than OrderViewController is presented, so in perpare for segue of MealsViewController OR MealDetailViewController they provide the selected Meal object to OrderViewController using this property */

@end
