//
//  RegisterViewController.m
//  Popinae
//
//  Created by Jamshaid on 06/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "Utility.h"
#import "Constant.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthContentView;

@end

@implementation RegisterViewController

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
#pragma - action methdos

- (IBAction)btnRegisterPressed:(id)sender {
    if ([self validateFields]) {
    
        [self callService];
        
    }else{
        [Utility showAlertWithTitle:@"Registration error" message:@"All fields are required !"];
    }
}

-(void)leftNavigationButtonPressed{
    [self.view endEditing:YES];
    [self dismissSelf];
}

#pragma - mark
#pragma - helper methods

- (void)setDefaults{
    // adding tap gesture recognizer to hide the keyboard when user taps any where in view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // other defaults
    self.contentView.backgroundColor = REGISTRATION_VC_BGCOLOR;
    [self addLeftNavigationButtonWithTitle:@"Cancel"];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.constraintHeightContentView.constant = screenSize.height;
    self.constraintWidthContentView.constant = screenSize.width;
    self.txtPassword.secureTextEntry = YES;
}

- (BOOL)validateFields{
    if ([self.txtName.text isEqualToString:@""]) {
        return NO;
    }else if([self.txtEmail.text isEqualToString:@""]){
        return NO;
    }
    else if (![Utility isValidEmail:self.txtEmail.text Strict:YES]){
        return NO;
    }
    else if ([self.txtPhone.text isEqualToString:@""]){
        return NO;
    }else if([self.txtPassword.text isEqualToString:@""]){
        return NO;
    }
    return YES;
}

-(void)callService{
    User* user = [User sharedUser];
    
    [user signupWithName:self.txtName.text email:self.txtEmail.text phone:self.txtPhone.text password:self.txtPassword.text completionHandler:^(NSError *error) {
        
        if (!error) {
            
            [self dismissSelf];
            
        }else{
            [Utility showAlertWithTitle:@"Registration error" message:error.localizedDescription];
        }
    }];
}

-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(userRegisteredWithSuccess:)]) {
                User* user = [User sharedUser];
                if ([user isUserTokenValid]) {
                    [self.delegate userRegisteredWithSuccess:YES];
                }else{
                    [self.delegate userRegisteredWithSuccess:NO];
                }
            }
        }
    }];
}

#pragma - mark
#pragma - overriddden methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // this method is not get called for some reason
    [self.view endEditing:YES];
}

#pragma - mark
#pragma - UIGesture recognizer related action method

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // hiding keyboard when user taps any where in the view
    [self.view endEditing:YES];
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
