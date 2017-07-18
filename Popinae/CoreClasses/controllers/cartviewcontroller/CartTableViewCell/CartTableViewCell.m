//
//  orderTableViewCell.m
//  Popinae
//
//  Created by Jamshaid on 30/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "CartTableViewCell.h"
#import "Constant.h"

@interface CartTableViewCell (){
    Meal* _myMeal;
}

@property (weak, nonatomic) IBOutlet UILabel *lblMealName;
@property (weak, nonatomic) IBOutlet UILabel *lblMealPrice;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = CART_VC_TABLE_VIEW_CELL_BGCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataWithMeal:(Meal*)meal{
    if (meal == nil) {
        return;
    }
    _myMeal = meal; // storing meal refrence locally
    self.lblMealName.text = [meal mealsTitle];
    NSString* mealPrice = [meal mealTotalPrice];
    self.lblMealPrice.text = [NSString stringWithFormat:@"%@%@",meal.currencySymbol,mealPrice];
}
-(Meal*)getStoredMeal{
    return _myMeal;
}

@end
