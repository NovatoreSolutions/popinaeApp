//
//  OrderTableViewCell.h
//  Popinae
//
//  Created by Jamshaid on 09/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Meal;


@interface OrderTableViewCell : UITableViewCell

-(void)populateData:(Meal*)meal;


@end
