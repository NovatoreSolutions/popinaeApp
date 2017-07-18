//
//  RegisterViewController.h
//  Popinae
//
//  Created by Jamshaid on 06/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseViewController.h"

@protocol RegisterViewControllerDelegate;

@interface RegisterViewController : BaseViewController

@property (weak,nonatomic) id<RegisterViewControllerDelegate> delegate;

@end

@protocol RegisterViewControllerDelegate <NSObject>

-(void)userRegisteredWithSuccess:(BOOL)success;

@end