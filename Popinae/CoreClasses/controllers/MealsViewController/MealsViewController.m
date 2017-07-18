//
//  MealsVC.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "MealsViewController.h"
#import "MealFeed.h"
#import "MealsTableViewCell/MealsTableViewCell.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "MapViewController.h"
#import "MealDetailsViewController.h"
#import "CartViewController.h"
#import "Order.h"
#import "LocationManager.h"
#import "RestaurantFeed.h"
#define CheckOutOrderViewHeight 50.0f

@interface MealsViewController ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate,LocationManagerDelegate,UISearchBarDelegate>

@property (strong,nonatomic) MealFeed *mealFeed;

@property (strong,nonatomic) NSMutableArray *mealFeedSearched;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UserLocation* userLocation;
@property (weak, nonatomic) IBOutlet UIView *checkoutOrderView;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckOutOrder;
@property (weak, nonatomic) IBOutlet UISearchBar *mealsSearchBar;
@property (nonatomic,assign)BOOL isFiltered;


- (IBAction)btnCheckOutOrderPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCheckoutOrder;
@end

@implementation MealsViewController

#pragma - mark
#pragma - life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaults];


}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkOrderAvailable];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma - mark
#pragma - location manager delegate methods

-(void)getRecentLocationReturnsWithLocation:(UserLocation *)location andErrorMessage:(NSString *)errorMsg{
    if (location) {
        _userLocation = location;
        [self callService];
    }else{
        [Utility showAlertWithTitle:@"Location error" message:errorMsg];
    }
}

#pragma - mark
#pragma - helper methods

-(void)setDefaults{
    [self showRightNavigationBarButton];
    _mealsSearchBar.delegate=self;
    if (_mealFeed == nil) {
        _mealFeed = [MealFeed sharedMealFeed];
    }
    
    
    for (UIView *subview in self.mealsSearchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                [textField setKeyboardAppearance: UIKeyboardAppearanceAlert];
                textField.returnKeyType = UIReturnKeyDone;
                break;
            }
        }
    }
    
    if (_isFromRestaurantViewController) {
        [self callServiceWithStoreId:_restaurant.storeId];
    }
    
    else{
        [self getLocationData];
    }
    
    

}


-(void)getLocationData{
    LocationManager* locationManager = [LocationManager sharedManager];
    locationManager.delegate = self;
    if ([locationManager isLocationServiceEnabled] == YES) {
        [locationManager getRecentLocation];
    }else{
        [Utility showAlertWithTitle:@"Location services disabled" message:@"You must turn on location services in your settings app to make this application gets meals for you, thanks !"];
    }
}

- (void)rightNavigationButtonPressed {
     // refresh data
    [self.mealFeed removeAllMeals];
    [self callService];
}

- (NSArray *)rightButtons{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f]
                                                title:@"Call"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.576f blue:0.204f alpha:1.0f]
                                                title:@"Map"];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.466f green:0.824f blue:0.294 alpha:1.0f]
                                                title:@"Order"];
    return rightUtilityButtons;
}

-(void)callService{
    if (_userLocation == nil) {
        return;
    }
    [self showActivityIndicator];
    [_mealFeed getMealsWithLatitude:[NSNumber numberWithDouble:_userLocation.userLocationLatitude]
                          longitude:[NSNumber numberWithDouble:_userLocation.userLocationLongitude]
                             radius:[NSNumber numberWithFloat:5.0]
                            keyword:nil
                             pageNo:[NSNumber numberWithInt:1]
                          recordsNo:[NSNumber numberWithInt:10]
                  completionHandler:^(NSError *error) {
                      
                      [self hideActivityIndicator];
                      if (error == nil) {
                          
                          [self.tableView reloadData];
                          
                      }else{
                          [Utility showAlertWithTitle:@"Meals error" message:error.localizedDescription];
                      }
    }];
}

-(void)callServiceWithStoreId:(NSString*)storeId{
   // if (_userLocation == nil) {
   //     return;
   // }
    [self showActivityIndicator];
    [_mealFeed getMealsWithMealId:nil  mealFamilyId:nil storeId:[NSNumber numberWithInt:storeId.intValue] sortBy:nil sortOrder:nil pageNo:nil recordsNo:nil lang:nil completionHandler:^(NSError *error) {
    
                      
                      [self hideActivityIndicator];
                      if (error == nil) {
                          
                          [self.tableView reloadData];
                        
                      }else{
                          [Utility showAlertWithTitle:@"Meals error" message:error.localizedDescription];
                      }
                  }];
}

-(void)checkOrderAvailable{
    
    Order *order = [Order sharedOrder];
    OrderState orderState = [order orderState];
    switch (orderState) {
        case OrderStateEmpty:
            if ([_mealFeed isCurrentlyShowingNearbyMeals] == NO) {
                [self callService];
                
                [self hideCheckoutOrderView];
            }
            
            break;
        case OrderStateMealAdded:
            if ([_mealFeed isCurrentlyShowingNearbyMeals] == YES) {
                [self showCheckoutOrderView];
                [self callServiceWithStoreId:[order getLastMeal].storeID];

            }
            break;
        case OrderStateNoChange:
        case OrderStateMealDeleted:
            [self.tableView reloadData];
            break;
    }
}
-(void)showCheckoutOrderView{
    self.constraintCheckoutOrder.constant = CheckOutOrderViewHeight;
    [self.checkoutOrderView setHidden:NO];
}
-(void)hideCheckoutOrderView{
    self.constraintCheckoutOrder.constant = 0;
    [self.checkoutOrderView setHidden:YES];
}
-(void)setDefaultQuantityForMeal:(Meal*)meal{
    NSString* mealQuantity = [NSString stringWithFormat:@"%d",1];
    [meal updateMealQuantity:mealQuantity];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isFiltered) {
        
        NSLog(@" search count ==> %lu",(unsigned long)[_mealFeedSearched count]);
        
        return [_mealFeedSearched count];
    }

    else if([_mealFeed mealsCount] > 0) {
        return [_mealFeed mealsCount];
    }
    else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  

    
    if (_isFiltered) {
        static NSString *cellIdentifier = @"MealsTableViewCell";
        MealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell populateData:[_mealFeedSearched objectAtIndex:indexPath.row]];
        return cell;
    }
    else if ([_mealFeed mealsCount] > 0){
        
        static NSString *cellIdentifier = @"MealsTableViewCell";
        MealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell populateData:[_mealFeed mealAtIndex:indexPath.row]];
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:63.0f];
        cell.delegate = self;
        return cell;
        
    }else if ([_mealFeed mealsCount]==0){

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        return cell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"MealDetailsViewController" sender:[_mealFeed mealAtIndex:indexPath.row]];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
          //  NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
            [Utility callNumber:@"123456"];
            break;
        }
        case 1:
        {
            NSLog(@"Map button pressed");
            
            NSIndexPath *cellIndexPath=[self.tableView indexPathForCell:cell];
            
            [self performSegueWithIdentifier:@"MapViewController" sender:[_mealFeed mealAtIndex:cellIndexPath.row]];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 2: // order button pressed
        {
            NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
            Meal *meal =  [_mealFeed mealAtIndex:cellIndexPath.row];
            Order* order = [Order sharedOrder];
            if ([order isThisMealAlreadyAdded:meal]) {
                [Utility showAlertWithTitle:@"Meal alerady in cart" message:@"You have already added this meal to cart !"];
            }else{
                // as user has select meal from list so meal quantity should be set to 1
                [self setDefaultQuantityForMeal:meal];
                // add meal in cart
               [order addNewMealInOrder:meal];
                // view cart
                [self performSegueWithIdentifier:@"CartViewController" sender:nil];
            }
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MealDetailsViewController"]) {
        
        Meal* meal = (Meal*)sender;
        
        // set a default meal quantity as user is going to view its details
        [self setDefaultQuantityForMeal:meal];
        
        MealDetailsViewController* mealDetailsViewController = (MealDetailsViewController*)segue.destinationViewController;
        
        mealDetailsViewController.meal = meal;
    }
    else if ([segue.identifier isEqualToString:@"MapViewController"]){
        
        MapViewController *mapViewController=(MapViewController *)segue.destinationViewController;
        mapViewController.isThisControllerOpenFromOtherController = YES;
        mapViewController.meal =(Meal *)sender;
    }
}

- (IBAction)btnCheckOutOrderPressed:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"CartViewController" sender:nil];
}

#pragma mark -UISearchBarDelegate Methods

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        _isFiltered = FALSE;
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
    }
    else
    {
        _isFiltered = true;
        if (!_mealFeedSearched) {
            _mealFeedSearched = [[NSMutableArray alloc] init];
        }
        
        for (Meal* meal in _mealFeed.mealFeed)
        {
            NSRange nameRange = [meal.mealTitle rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound)
            {
                [_mealFeedSearched removeAllObjects];
                [_mealFeedSearched addObject:meal];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


@end
