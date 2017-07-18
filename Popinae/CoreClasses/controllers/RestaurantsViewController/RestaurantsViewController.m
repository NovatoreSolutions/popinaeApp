//
//  RestaurantsViewController.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "RestaurantFeed.h"
#import "RestaurantTableViewCell/RestaurantTableViewCell.h"
#import "Utility.h"
#import "MapViewController.h"
#import "MealFeed.h"
#import "MealsViewController.h"
#import "RestaurantDetailViewController.h"


@interface RestaurantsViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UISearchBarDelegate>

@property (strong,nonatomic) MealFeed *mealFeed;

@property (strong,nonatomic) RestaurantFeed *restaurantFeed;
@property (strong,nonatomic) NSMutableArray *restaurantFeedSearched;

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *restaurantSearchBar;
@property (nonatomic,assign)BOOL isFiltered;

@end

@implementation RestaurantsViewController

#pragma - mark
#pragma - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaults];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightNavigationButtonPressed {
    // refresh data
    [self.restaurantFeed removeAllRestaurants];
    [self callService];
}


#pragma - mark
#pragma - Helper methods

-(void)setDefaults{
    [self showRightNavigationBarButton];
 _restaurantSearchBar.delegate=self;
    if (_restaurantFeed == nil) {
        _restaurantFeed = [RestaurantFeed sharedRestaurantFeed];
    }
    
    
    for (UIView *subview in self.restaurantSearchBar.subviews)
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
    
    
    
    [self callService];
}

-(void)callService{
    
    [self showActivityIndicator];
    
    if (_restaurantFeed == nil) {
        _restaurantFeed = [[RestaurantFeed alloc] init];
    }
    
    [_restaurantFeed getRestaurantsWithKeyword:nil storeId:nil sortBy:nil sortOrder:nil pageNo:[NSNumber numberWithInt:1] recordsNo:[NSNumber numberWithInt:10] completionHandler:^(NSError *error){
        
        [self hideActivityIndicator];
        if (!error) {
            
            [_restaurantTableView reloadData];
            
        }else {
            
        }
    }];
    
    
    
}

#pragma - mark
#pragma - Search controller methods




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFiltered) {
        
        NSLog(@" search count ==> %lu",(unsigned long)[_restaurantFeedSearched count]);
        
        return [_restaurantFeedSearched count];
    }
    else if([_restaurantFeed restaurantsCount] > 0) {
        return [_restaurantFeed restaurantsCount];
    }
    else{
        return 1;
    }

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_isFiltered) {
        static NSString *cellIdentifier = @"RestaurantTableViewCell";
        RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell populateData:[_restaurantFeedSearched objectAtIndex:indexPath.row]];
        
        
        return cell;

        
    }
    else if([_restaurantFeed restaurantsCount] > 0){
        static NSString *cellIdentifier = @"RestaurantTableViewCell";
        RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell populateData:[_restaurantFeed restaurantAtIndex:indexPath.row]];
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:63.0f];
        cell.delegate = self;
        return cell;
    }
    else if([_restaurantFeed restaurantsCount] == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        return cell;
    }

    return  nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"RestaurantDetailsViewController" sender:[_restaurantFeed restaurantAtIndex:indexPath.row]];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MapViewController"]){
        MapViewController *mapViewController=(MapViewController *)segue.destinationViewController;
        mapViewController.isThisControllerOpenFromRestaurant = YES;
        mapViewController.restaurant =(Restaurant *)sender;
    }
    
    else if ([segue.identifier isEqualToString:@"MealsViewController"]){
        MealsViewController *mealsViewController =(MealsViewController *)segue.destinationViewController;
        mealsViewController.isFromRestaurantViewController=YES;
        mealsViewController.restaurant= (Restaurant *)sender;
        
    }
    
    else if ([segue.identifier isEqualToString:@"RestaurantDetailsViewController"]){
        RestaurantDetailViewController *restaurantDetailViewController=(RestaurantDetailViewController *)segue.destinationViewController;
        restaurantDetailViewController.restaurant = (Restaurant *)sender;
        
    }
}

#pragma - mark
#pragma - SWTableViewDelegate

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f]
                                                title:@"Call"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.576f blue:0.204f alpha:1.0f]
                                                title:@"Map"];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.466f green:0.824f blue:0.294 alpha:1.0f]
                                                title:@"Meals"];
    
    return rightUtilityButtons;
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
             NSIndexPath *cellIndexPath=[self.restaurantTableView indexPathForCell:cell];
            [Utility callNumber:[_restaurantFeed restaurantAtIndex:cellIndexPath.row].storePhone];
            
            break;
        }
        case 1:
        {
            NSLog(@"Map Button Pressed");
            
            NSIndexPath *cellIndexPath=[self.restaurantTableView indexPathForCell:cell];
            
            [self performSegueWithIdentifier:@"MapViewController" sender:[_restaurantFeed restaurantAtIndex:cellIndexPath.row]];
        
            [cell hideUtilityButtonsAnimated:YES];
            
            
            break;
        }
        case 2:
        {
            NSLog(@"Meals Button Pressed");
            NSIndexPath *cellIndexPath=[self.restaurantTableView indexPathForCell:cell];
            
            [self performSegueWithIdentifier:@"MealsViewController" sender:[_restaurantFeed restaurantAtIndex:cellIndexPath.row]];
            
            [cell hideUtilityButtonsAnimated:YES];
    
            break;
        }
            
        default:
            break;
    }
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
    if (!_restaurantFeedSearched) {
        _restaurantFeedSearched = [[NSMutableArray alloc] init];
    }
    
        
        
        for (Restaurant* restaurant in _restaurantFeed.restaurantFeed)
        {
            NSRange nameRange = [restaurant.storeName rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound)
            {
            [_restaurantFeedSearched removeAllObjects];
                [_restaurantFeedSearched addObject:restaurant];
            }
        }
    }
    
    [self.restaurantTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

@end
