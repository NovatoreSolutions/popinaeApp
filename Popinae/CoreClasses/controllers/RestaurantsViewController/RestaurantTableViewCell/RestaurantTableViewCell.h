//
//  RestaurantTableViewCell.h
//  Popinae
//
//  Created by AMK on 01/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>

@class Restaurant;

@interface RestaurantTableViewCell : SWTableViewCell

-(void)populateData:(Restaurant*)restaurant;

@end
