//
//  LoginViewController.h
//  Popinae
//
//  Created by Jamshaid on 06/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseViewController.h"

@protocol LoginViewControllerDelegate;

@interface LoginViewController : BaseViewController

@property (weak,nonatomic) id<LoginViewControllerDelegate> delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

-(void)userLoginWithSuccess:(BOOL)success;

@end