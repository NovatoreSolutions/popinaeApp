//
//  MealDetailsViewController.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "MealDetailsViewController.h"
#import "NYSliderPopover.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MealFeed.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Borders.h"
#import "CartViewController.h"
#import "Order.h"
#import "Utility.h"
#import "MapViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>


#define kBtnCornerRadius 5.0f

@interface MealDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *mealDescriptionTxtView;
@property (weak, nonatomic) IBOutlet NYSliderPopover *slider;
@property (weak, nonatomic) IBOutlet UILabel *meal_Title;
@property (weak, nonatomic) IBOutlet UILabel *mealRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *meal_Price;
@property (weak, nonatomic) IBOutlet UIView *mealdetailView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)mapBtn:(id)sender;
- (IBAction)mealRestaurantBtn:(id)sender;
- (IBAction)sliderValueChange:(id)sender;
- (IBAction)btnOrderPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

@end

@implementation MealDetailsViewController

#pragma - mark
#pragma - lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDefaults];
}
-(void)viewDidAppear:(BOOL)animated{
    // set initial value of slider according to current meal quantity
    [UIView animateWithDuration:5.0f animations:^{
        [self.slider setValue:[self.meal.quantity intValue] animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark
#pragma - helper methods

-(void)setDefaults{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_meal.mealImage]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.activityIndicator stopAnimating];
    }];
    self.mealDescriptionTxtView.text=_meal.mealDescription;
    self.meal_Title.text = _meal.mealTitle;
    self.mealRestaurant.text = _meal.storeName;
    self.meal_Price.text = [NSString stringWithFormat:@"%@%@",_meal.currencySymbol,_meal.mealPrice];
    [self updateSliderPopoverText];
    
    _mealdetailView.backgroundColor = DETAIL_MIDDLE_BAR_COLOR;
    
    [_mealdetailView addBottomBorderWithHeight:1.0f andColor:DETAIL_SEPARATOR_COLOR];
    
    [_bottomContainerView addTopBorderWithHeight:1.0f andColor:DETAIL_SEPARATOR_COLOR];
    
    [_btnOrder setBackgroundColor:DETAIL_ORDER_BTN_COLOR];
    
    [self.bottomContainerView bringSubviewToFront:_slider.popover];
    CALayer *layer = _btnOrder.layer;
    layer.cornerRadius = kBtnCornerRadius;
}

-(void)updateSliderPopoverText
{
    self.slider.popover.textLabel.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
}

#pragma mark - Action methods

- (IBAction)mapBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"MapViewController" sender:_meal];
    
}

- (IBAction)mealRestaurantBtn:(id)sender {
}

- (IBAction)sliderValueChange:(id)sender {
    [self updateSliderPopoverText];
}

- (void)orderPlace:(id)value {
    Order* order = [Order sharedOrder];
    
    if ([order isThisMealAlreadyAdded:self.meal]) {
        [Utility showAlertWithTitle:@"Meal already in cart" message:@"You have already added this meal to cart !"];
    }
    else{
        // update meal quantity according to current slider value
       // NSString* mealQuantity = [NSString stringWithFormat:@"%d", (int)self.slider.value];
        NSString* mealQuantity = [NSString stringWithFormat:@"%@", value];
        [self.meal updateMealQuantity:mealQuantity];
        // add meal to cart
        [order addNewMealInOrder:self.meal];
        // view cart
        [self performSegueWithIdentifier:@"CartViewController" sender:nil];
    }
}

- (IBAction)btnOrderPressed:(id)sender {
    
    NSArray *mealCounter = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Meal Quantity"
                                            rows:mealCounter
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@", picker);
                                           NSLog(@"Selected Index: %ld", (long)selectedIndex);
                                           NSLog(@"Selected Value: %@", selectedValue);
                                           [self orderPlace:selectedValue];
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:self.view];
    





    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapViewController"]){
        
        MapViewController *mapViewController=(MapViewController *)segue.destinationViewController;
        mapViewController.isThisControllerOpenFromOtherController = YES;
        mapViewController.meal =(Meal *)sender;
    }


}


@end
