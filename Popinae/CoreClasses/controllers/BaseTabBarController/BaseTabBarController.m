//
//  BaseTabBarController.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseTabBarController.h"
#import "Constant.h"
@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UITabBar appearance] setTintColor:APP_THEME];
    [[UITabBar appearance] setBarTintColor:BAR_TINT_COLOR];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:TAB_BAR_ITEM_ACTIVE forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:TAB_BAR_ITEM_INACTIVE forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
