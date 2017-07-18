//
//  TableViewCustomHeader.m
//  Popinae
//
//  Created by Jamshaid on 31/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "TableViewCustomHeader.h"
#import "Constant.h"

@implementation TableViewCustomHeader

+(id)tableViewCustomHeader{
    TableViewCustomHeader* tableViewCustomHeader = (TableViewCustomHeader*) [[[NSBundle mainBundle]loadNibNamed:@"TableViewCustomHeader" owner:self options:nil] lastObject];
    if ([tableViewCustomHeader isKindOfClass:[TableViewCustomHeader class]]) {
        tableViewCustomHeader.backgroundColor = CART_VC_TABLE_VIEW_HEADER_BGCOLOR;
        return tableViewCustomHeader;
    }else{
        return nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
