//
//  OrderTableViewCellHeader.m
//  Popinae
//
//  Created by Jamshaid on 09/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "OrderTableViewCellHeader.h"
#import "Constant.h"

@interface OrderTableViewCellHeader()
@property (weak, nonatomic) IBOutlet UIView *topSeparatorView;

@property (weak, nonatomic) IBOutlet UIView *upperSubView;

@property (weak, nonatomic) IBOutlet UILabel *lblResturant;


@property (weak, nonatomic) IBOutlet UIButton *btnResturant;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;


@property (weak, nonatomic) IBOutlet UIView *middleSeparatorView;
@property (weak, nonatomic) IBOutlet UIView *bottomSubView;

@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView1;


@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusDetails;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;


@end

@implementation OrderTableViewCellHeader

+(OrderTableViewCellHeader*)orderTableViewCellHeader{
    OrderTableViewCellHeader* header = (OrderTableViewCellHeader*)[[[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCellHeader" owner:nil options:nil] lastObject];
    if ([header isKindOfClass:[OrderTableViewCellHeader class]]) {
        [header setSubViewsColors];
        return header;
    }else{
        return nil;
    }
}

-(void)setSubViewsColors{
    self.topSeparatorView.backgroundColor = ORDERS_VC_TABLE_VIEW_HEADER_SEPARATOR_COLOR;
    self.middleSeparatorView.backgroundColor = ORDERS_VC_TABLE_VIEW_HEADER_SEPARATOR_COLOR;
    self.bottomSeparatorView1.backgroundColor = ORDERS_VC_TABLE_VIEW_HEADER_SEPARATOR_COLOR;
    self.bottomSeparatorView.backgroundColor = ORDERS_VC_TABLE_VIEW_HEADER_SEPARATOR_COLOR;
    self.upperSubView.backgroundColor = ORDERS_VC_TABLE_VIEW_HEADER_UPPER_SUBVIEW_BGCOLOR;
    self.bottomSubView.backgroundColor = ORDERS_VC_TABLE_VIEW_HEADER_BOTTOM_SUBVIEW_BGCOLOR;
    self.lblStatusDetails.textColor = ORDERS_VC_TABLE_VIEW_HEADER_LABEL_STATUS_DETAILS_TEXTCOLOR;
}

- (IBAction)btnResturantPressed:(id)sender {
}
- (IBAction)btnMapPressed:(id)sender {
}
- (IBAction)btnPhonePressed:(id)sender {
}

@end
