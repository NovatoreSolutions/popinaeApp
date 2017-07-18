//
//  BaseVC.h
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showNavigationBar;
- (void)hideNavigationBar;
- (void)addRightNavigationButtonWithImage:(NSString*)imageName;
-(void)showRightNavigationBarButton;
- (void)addLeftNavigationButtonWithImage:(NSString*)imageName;
-(void)showLeftNavigationBarButton;
- (void)leftNavigationButtonPressed;
- (void)rightNavigationButtonPressed;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showActivityIndicatorInView;
- (void)userInteractionEnabledOnActivity:(BOOL)mode;
- (void)addRightNavigationButtonWithTitle:(NSString*)title;
- (void)addLeftNavigationButtonWithTitle:(NSString*)title;


@end

