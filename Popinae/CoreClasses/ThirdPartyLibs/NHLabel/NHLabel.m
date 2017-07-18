//
//  NHLabel.m
//  nethosting
//
//  Created by Jawad Waheed on 14/02/2014.
//  Copyright (c) 2014 Jawad Waheed. All rights reserved.
//

#import "NHLabel.h"

@implementation NHLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setTextColor:[Utility appTextColor]];
        [self setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:17]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [self setTextColor:[Utility appTextColor]];
    [self setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:17]];
    
    
}

@end
