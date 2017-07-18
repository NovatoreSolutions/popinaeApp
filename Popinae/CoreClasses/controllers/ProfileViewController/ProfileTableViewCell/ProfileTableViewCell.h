//
//  ProfileTableViewCell.h
//  Popinae
//
//  Created by AMK on 02/03/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileTableViewCell : UITableViewCell

-(void)populateDataWithTitle: (NSString *)firstLabel Value:(NSString *)secondLabel;

@end
