//
//  OrderTableViewCellFooter.m
//  Popinae
//
//  Created by Jamshaid on 09/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "OrderTableViewCellFooter.h"
#import "Constant.h"


@interface OrderTableViewCellFooter()
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;


@end

@implementation OrderTableViewCellFooter

+(OrderTableViewCellFooter*)orderTableViewCellFooter{
    OrderTableViewCellFooter* footer = [[[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCellFooter" owner:nil options:nil] lastObject];
    if ([footer isKindOfClass:[OrderTableViewCellFooter class]]) {
        [footer setSubViewsColors];
        return footer;
    }else{
        return nil;
    }
}

-(void)setSubViewsColors{
    self.backgroundColor = ORDERS_VC_TABLE_VIEW_FOOTER_BGCOLOR;
    self.separatorView.backgroundColor = ORDERS_VC_TABLE_VIEW_FOOTER_SEPARATOR_COLOR;
}

@end
