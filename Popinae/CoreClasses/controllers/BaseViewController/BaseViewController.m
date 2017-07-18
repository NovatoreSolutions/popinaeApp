//
//  BaseVC.m
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseViewController.h"
#import <AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIColor+ColorWithHex.h>
#import "Constant.h"
#import "Utility.h"
#import <SpinKit/RTSpinKitView.h>

@interface BaseViewController (){
    MBProgressHUD *activityView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_bar.png"]];
    
        //    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    activityView = [[MBProgressHUD alloc] init];
    activityView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:activityView];
    
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleChasingDots color:[UIColor whiteColor]];
    
    activityView.mode = MBProgressHUDModeCustomView;
    activityView.customView = spinner;
    activityView.animationType = MBProgressHUDAnimationFade;
    activityView.dimBackground = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:NAV_BAR_COLOR andAlpha:1.0f];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:NAV_BAR_TINT_COLOR andAlpha:1.0f];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"AvenirNext-Medium" size:17], NSFontAttributeName,
                                [UIColor colorWithHexString:NAV_BAR_TEXT_COLOR andAlpha:1.0f ], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"AvenirNext-Medium" size:13], NSFontAttributeName,
                                      nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:normalAttributes
                                                forState:UIControlStateNormal];
        //self.view.backgroundColor = [UIColor colorWithHexString:APP_BACKGROUND_COLOR andAlpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popinae-logo.png"]];
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)hideNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)showNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
}


-(void)addRightNavigationButton
{
    self.navigationItem.rightBarButtonItem = nil;
   
    
   // UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightNavigationButtonPressed)];
    UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightNavigationButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightbarButton;
}


- (void)addRightNavigationButtonWithImage:(NSString*)imageName
{
    self.navigationItem.rightBarButtonItem = nil;
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightNavigationButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightbarButton;
}

- (void)rightNavigationButtonPressed {
}



- (void)addLeftNavigationButtonWithImage:(NSString*)imageName
{
//    self.navigationItem.rightBarButtonItem = nil;
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftNavigationButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftbarButton;
}

-(void)leftNavigationButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)addLeftNavigationButtonWithTitle:(NSString*)title
{
        //    self.navigationItem.rightBarButtonItem = nil;
    
    UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftNavigationButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftbarButton;
}



- (void)addRightNavigationButtonWithTitle:(NSString*)title
{

    
    UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightNavigationButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightbarButton;
}



-(void)showLeftNavigationBarButton{
    [self addLeftNavigationButtonWithImage:@"icon_back.png"];
    
}
-(void)showRightNavigationBarButton{
   // [self addRightNavigationButtonWithImage:@"icon_menu.png"];
    [self addRightNavigationButton];
    
}


- (void)showActivityIndicator
{
    [activityView show:YES];
}

- (void)showActivityIndicatorInView
{
    [self.view addSubview:activityView];
    [activityView show:YES];
}

- (void)hideActivityIndicator
{
    [activityView hide:YES];
}

- (void)userInteractionEnabledOnActivity:(BOOL)mode {
    [activityView removeFromSuperview];
    activityView = [[MBProgressHUD alloc] init];
    [self.view addSubview:activityView];
    activityView.mode = MBProgressHUDModeIndeterminate;
    activityView.animationType = MBProgressHUDAnimationFade;
    activityView.dimBackground = NO;
    activityView.userInteractionEnabled = mode;
}





@end
