//
//  OrdersViewController.m
//  Popinae
//
//  Created by Jamshaid on 08/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "OrdersViewController.h"
#import "PlacedOrdersFeed.h"
#import "OrderTableViewCell.h"
#import "OrderTableViewCellHeader.h"
#import "OrderTableViewCellFooter.h"

@interface OrdersViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray* orders;

@end

@implementation OrdersViewController

#pragma - mark
#pragma - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDefaults];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self callService]; // get fresh data each time view appears
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark
#pragma - Helper Methods

-(void)setDefaults{
    self.orders = [PlacedOrdersFeed dummyPlacedOrders];
    [self showRightNavigationBarButton];
}
-(void)callService{
    // request server to get list of orders, fill model, than reload table
}
-(void)rightNavigationButtonPressed{
    [self callService]; // to get fresh data
}

#pragma - mark
#pragma - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orders.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PlacedOrder* placedOrder = (PlacedOrder*)self.orders[section];
    return placedOrder.placedOrderMeals.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlacedOrder* placedOrder = (PlacedOrder*)self.orders[indexPath.section];
    Meal* meal = (Meal*)placedOrder.placedOrderMeals[indexPath.row];
    OrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    [cell populateData:meal];
    return cell;
}

#pragma - mark
#pragma - UITableViewDelegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [OrderTableViewCellHeader orderTableViewCellHeader];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [OrderTableViewCellFooter orderTableViewCellFooter];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 89.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 39.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // removing white spaces at the left of cell separators, works in both iOS 7 and iOS 8
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
