//
//  OrderTableViewCell.m
//  Popinae
//
//  Created by Jamshaid on 09/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "MealFeed.h"
#import "Constant.h"

@interface OrderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblMealTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMealPrice;

@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSubViewsColors];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSubViewsColors{
    self.contentView.backgroundColor = ORDERS_VC_TABLE_VIEW_CELL_BGCOLOR;
}
-(void)populateData:(Meal *)meal{
    self.lblMealTitle.text = meal.mealTitle;
    self.lblMealPrice.text = meal.mealPrice;
}

@end
