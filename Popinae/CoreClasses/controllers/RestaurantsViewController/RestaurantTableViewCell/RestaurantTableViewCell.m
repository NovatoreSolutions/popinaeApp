//
//  RestaurantTableViewCell.m
//  Popinae
//
//  Created by AMK on 01/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "RestaurantTableViewCell.h"
#import "RestaurantFeed.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface RestaurantTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDistance;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation RestaurantTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateData:(Restaurant *)restaurant
{
    _restaurantName.text= restaurant.storeName;
   [_restaurantImage sd_setImageWithURL:[NSURL URLWithString:restaurant.storeImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
       [_activityIndicator stopAnimating];
       
   }];
    _restaurantDistance.text=[NSString stringWithFormat:@"%.2f %@",restaurant.storeDistance,@"km"];
    
}



@end
