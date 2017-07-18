//
//  MealsTableViewCell.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "MealsTableViewCell.h"
#import "MealFeed.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MealsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *mealImage;
@property (weak, nonatomic) IBOutlet UILabel *mealName;
@property (weak, nonatomic) IBOutlet UILabel *mealDescription;
@property (weak, nonatomic) IBOutlet UILabel *mealPrice;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MealsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateData:(Meal*)meal{
    
    self.mealName.text= meal.mealTitle;
    self.mealDescription.text = meal.storeName;
    self.mealPrice.text = [NSString stringWithFormat:@"%@%@",meal.currencySymbol,meal.mealPrice];
    [self.mealImage sd_setImageWithURL:[NSURL URLWithString:meal.mealImage]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.activityIndicator stopAnimating];
    }];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.mealName.text= @"";
    self.mealDescription.text = @"";
    self.mealPrice.text = @"";
//    self.mealImage = nil;
    
}
@end
