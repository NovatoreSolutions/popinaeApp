//
//  ProfileTableViewCell.m
//  Popinae
//
//  Created by AMK on 02/03/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "ProfileTableViewCell.h"


@interface ProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *profileLabelName;

@property (weak, nonatomic) IBOutlet UILabel *profileLabelText;

@end

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataWithTitle: (NSString *)firstLabel Value:(NSString *)secondLabel{
    
    self.profileLabelName.text = firstLabel;
    self.profileLabelText.text = secondLabel;
    
}


@end
