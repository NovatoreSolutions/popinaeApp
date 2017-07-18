//
//  MapViewController.h
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@class Meal;
@class Restaurant;


@interface MapViewController : BaseViewController

@property (strong,nonatomic) Meal *meal;
@property (strong,nonatomic) Restaurant *restaurant;
@property (assign, nonatomic) BOOL isThisControllerOpenFromOtherController;
@property (assign, nonatomic) BOOL isThisControllerOpenFromRestaurant;




@end
