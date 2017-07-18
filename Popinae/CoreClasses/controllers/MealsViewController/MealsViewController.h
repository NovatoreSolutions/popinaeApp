//
//  MealsVC.h
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseViewController.h"
@class Restaurant;


@interface MealsViewController : BaseViewController

@property(nonatomic,assign)BOOL isFromRestaurantViewController;
@property(nonatomic,strong)Restaurant *restaurant;


@end
