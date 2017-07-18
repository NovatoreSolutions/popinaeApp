//
//  RestaurantDetailViewController.m
//  Popinae
//
//  Created by AMK on 24/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RestaurantFeed.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Borders.h"
#import "Utility.h"
#import "MapViewController.h"



#define kBtnCornerRadius 5.0f

@interface RestaurantDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imgActivityIndicator;
- (IBAction)mapBtn:(id)sender;
- (IBAction)callBtn:(id)sender;


@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)setDefaults{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_restaurant.storeImage]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imgActivityIndicator stopAnimating];
    }];
    
    self.restaurantName.text = _restaurant.storeName;
    self.restaurantAddress.text = _restaurant.storeAddress;
    
    
    _middleView.backgroundColor = DETAIL_MIDDLE_BAR_COLOR;
    
    [_middleView addBottomBorderWithHeight:1.0f andColor:DETAIL_SEPARATOR_COLOR];
    
   /* [_bottomContainerView addTopBorderWithHeight:1.0f andColor:DETAIL_SEPARATOR_COLOR];
    
    [_btnOrder setBackgroundColor:DETAIL_ORDER_BTN_COLOR];
    
    [self.bottomContainerView bringSubviewToFront:_slider.popover];
    CALayer *layer = _btnOrder.layer;
    layer.cornerRadius = kBtnCornerRadius;*/
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapViewController"]){
        MapViewController *mapViewController=(MapViewController *)segue.destinationViewController;
        mapViewController.isThisControllerOpenFromRestaurant = YES;
        mapViewController.restaurant =(Restaurant *)sender;
    }
}

- (IBAction)mapBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"MapViewController" sender:_restaurant];
}

- (IBAction)callBtn:(id)sender {
    
    [Utility callNumber:_restaurant.storePhone];
}
@end
