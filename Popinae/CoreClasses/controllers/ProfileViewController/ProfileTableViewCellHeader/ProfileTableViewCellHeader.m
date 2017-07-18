//
//  ProfileTableViewCellHeader.m
//  Popinae
//
//  Created by AMK on 02/03/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "ProfileTableViewCellHeader.h"
#import "Constant.h"

@interface ProfileTableViewCellHeader()

@property (weak, nonatomic) IBOutlet UILabel *profileCellHeaderLabel;

@end

@implementation ProfileTableViewCellHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(ProfileTableViewCellHeader*)profileTableViewCellHeader:(NSString *)label{
    ProfileTableViewCellHeader* header = (ProfileTableViewCellHeader*)[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCellHeader" owner:nil options:nil] lastObject];
    if ([header isKindOfClass:[ProfileTableViewCellHeader class]]) {
        [header setSubViewsColors];
        header.backgroundColor=ORDERS_VC_TABLE_VIEW_HEADER_UPPER_SUBVIEW_BGCOLOR;
        header.profileCellHeaderLabel.text=label;
        
        return header;
    }else{
        return nil;
    }
}

-(void)setSubViewsColors{
    
   // self.profileCellHeaderViewBackgroundView.backgroundColor = ORDERS_VC_TABLE_VIEW_HEADER_UPPER_SUBVIEW_BGCOLOR;
    self.profileCellHeaderLabel.backgroundColor=ORDERS_VC_TABLE_VIEW_HEADER_UPPER_SUBVIEW_BGCOLOR;
    self.profileCellHeaderLabel.textColor = ORDERS_VC_TABLE_VIEW_HEADER_LABEL_STATUS_DETAILS_TEXTCOLOR;
}

@end
