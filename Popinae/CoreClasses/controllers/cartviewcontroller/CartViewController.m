//
//  OrderViewController.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "Order.h"
#import "TableViewCustomHeader.h"
#import "User.h"
#import "Cart.h"
#import "LoginViewController.h"
#import "Utility.h"
#import "UIView+Borders.h"
#import "Constant.h"

@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) TableViewCustomHeader* tableViewCustomHeader;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerOrderDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

@end

@implementation CartViewController

#pragma - mark 
#pragma - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDefaults];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateOrderPrice]; // update the price in table view header each time view appears
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark
#pragma - Helper Methods

-(void)setDefaults{
    self.view.backgroundColor = CART_VC_MAIN_VIEW_BGCOLOR;
    self.pickerOrderDateTime.backgroundColor = CART_VC_PICKER_VIEW_BGCOLOR;
    self.btnCancel.backgroundColor = CART_VC_CANCEL_BUTTON_BGCOLOR;
    self.btnOrder.backgroundColor = CART_VC_ORDER_BUTTON_BGCOLOR;
    self.navigationItem.hidesBackButton = YES;
    self.pickerOrderDateTime.minimumDate = [NSDate date];
    // adding table view custom header view
    self.tableViewCustomHeader = (TableViewCustomHeader*) [TableViewCustomHeader tableViewCustomHeader];
    self.tableViewCustomHeader.lblOrderTotal.text = @"Order Total";
    self.tableViewCustomHeader.lblOrderPrice.text = @"$0.00";
    self.tableView.tableHeaderView = self.tableViewCustomHeader;
    [self.tableViewCustomHeader addBottomBorderWithHeight:1.0f andColor:DETAIL_SEPARATOR_COLOR];
}

-(void)updateOrderPrice{
    Order* order = [Order sharedOrder];
    float orderTotal = [order getTheOrderTotal];
    self.tableViewCustomHeader.lblOrderPrice.text = [NSString stringWithFormat:@"$%.02f",orderTotal];
}

-(void)callService{
    // write code to send order confirmation service, in completion handler clear the meals or empty order and than segue to meals view controller
}

#pragma - mark
#pragma - LoginViewController Delegate Methods

-(void)userLoginWithSuccess:(BOOL)success{
    if (success) {
       User* user = [User sharedUser];
        NSLog(@"user success = %@",user.description);
       [self callService];
    }else{
        [Utility showAlertWithTitle:@"Unable to send order confirmation" message:@"You must be logged in in order to confirm order"];
    }
}

#pragma - mark
#pragma - Action Methods

- (IBAction)dateTimeDidChanged:(id)sender {
    UIDatePicker* picker = (UIDatePicker*)sender;
    Order* order = [Order sharedOrder];
    order.orderDate = picker.date;
}

- (IBAction)btnCancelPressed:(id)sender {
    Order* order = [Order sharedOrder];
    [order refreshOrder];
    [self updateOrderPrice];
    [self.tableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
    // navigate to meals list screen without any filters
}
- (IBAction)btnOrderPressed:(id)sender {
    
    // if user is logged in and token is valid than call service else present login view, and in its delegate if user log in is success than call service from their
    
    User* user = [User sharedUser];
    
    if ([user isUserTokenValid]) {
        
        [self callService];
    }else{
        // present login view controller
        [self performSegueWithIdentifier:@"modalSegueToLoginVC" sender:nil];
    }
}

#pragma - mark
#pragma - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Order* order = [Order sharedOrder];
    return [order getNumberOfMealsInOrder];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CartTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell"];
    Order* order = [Order sharedOrder];
    Meal* currentMeal = [order getMealAtIndex:indexPath.row];
    [cell populateDataWithMeal:currentMeal];
    return cell;
}

#pragma - mark
#pragma - UITableViewDelegate Methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView beginUpdates];
    // deleting cell and corresponding meal on swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // removing meal from order
        CartTableViewCell* cellAtIndexPath = (CartTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        Meal* storedMeal = [cellAtIndexPath getStoredMeal];
        Order* order = [Order sharedOrder];
        [order removeThisMealFromOrder:storedMeal];
        // deleting row
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self updateOrderPrice];
    [tableView endUpdates];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 39.0f;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"modalSegueToLoginVC"]) {
        UINavigationController* navigationController = (UINavigationController*)segue.destinationViewController;
        LoginViewController* loginViewController = (LoginViewController*)[navigationController.viewControllers lastObject];
        loginViewController.delegate = self;
    }
}


@end
