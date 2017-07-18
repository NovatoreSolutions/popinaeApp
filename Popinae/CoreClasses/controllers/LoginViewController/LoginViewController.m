//
//  LoginViewController.m
//  Popinae
//
//  Created by Jamshaid on 06/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "RegisterViewController.h"
#import "Utility.h"
#import "Constant.h"

@interface LoginViewController ()<UITextFieldDelegate,RegisterViewControllerDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthContentView;

@end

@implementation LoginViewController

#pragma - mark
#pragma - life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDefaults];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark
#pragma - helper methods

- (void)setDefaults{
    // adding tap gesture recognizer to hide the keyboard when user taps any where in view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // other defaults
    self.contentView.backgroundColor = LOGIN_VC_BGCOLOR;
    [self addLeftNavigationButtonWithTitle:@"Cancel"];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.constraintHeightContentView.constant = screenSize.height;
    self.constraintWidthContentView.constant = screenSize.width;
    self.txtPassword.secureTextEntry = YES;
}

- (BOOL)validateFields{
    if ([self.txtUserName.text isEqualToString:@""]) {
        return NO;
    }
    else if (![Utility isValidEmail:self.txtUserName.text Strict:YES]){
        return NO;
    }
    else if([self.txtPassword.text isEqualToString:@""]){
        return NO;
    }
    return YES;
}

-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(userLoginWithSuccess:)]) {
                User* user = [User sharedUser];
                if ([user isUserTokenValid]) {
                    [self.delegate userLoginWithSuccess:YES];
                }else{
                    [self.delegate userLoginWithSuccess:NO];
                }
                
            }
        }
    }];
}

#pragma - mark
#pragma - UIGesture recognizer related action method

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // hiding keyboard when user taps any where in the view
    [self.view endEditing:YES];
}

#pragma - mark
#pragma - Overridden Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // this method is not get called for some reason
    NSLog(@"touch began");
    [self.view endEditing:YES];
}

#pragma - mark
#pragma - RegisterViewController Delegate Methods

-(void)userRegisteredWithSuccess:(BOOL)success{
    if (success) {
        NSLog(@"user registration is success");
    }else{
        NSLog(@"user registration is failed");
    }
}

#pragma - mark
#pragma - action methods

-(void)leftNavigationButtonPressed{
    
    [self.view endEditing:YES];
    [self dismissSelf];
}

- (void)callService {
    
    User* user = [User sharedUser];
    [user loginWithUsername:self.txtUserName.text password:self.txtPassword.text completionHandler:^(NSError *error) {
        if (!error) {
            [self dismissSelf];
        }else{
            [Utility showAlertWithTitle:@"Login error" message:error.localizedDescription];
        }
    }];
}

- (IBAction)btnLoginPressed:(id)sender {
    if ([self validateFields]) {
        [self callService];
    }else{
        [Utility showAlertWithTitle:@"Login error" message:@"All fields are required !"];
    }
}

- (IBAction)btnRegisterPressed:(id)sender {
    [self performSegueWithIdentifier:@"modalSegueToRegisterVC" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modalSegueToRegisterVC"]) {
        UINavigationController* navigationController = (UINavigationController*)segue.destinationViewController;
        RegisterViewController* registerViewController = (RegisterViewController*)[navigationController.viewControllers lastObject];
        registerViewController.delegate = self;
    }
}

@end
