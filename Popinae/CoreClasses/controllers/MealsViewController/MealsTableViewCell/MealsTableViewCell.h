//
//  MealsTableViewCell.h
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>

@class Meal;

@interface MealsTableViewCell : SWTableViewCell

-(void)populateData:(Meal*)meal;

@end
