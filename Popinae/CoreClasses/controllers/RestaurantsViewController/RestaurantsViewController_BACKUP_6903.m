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


@interface RestaurantsViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UISearchBarDelegate>

@property (strong,nonatomic) RestaurantFeed *restaurantFeed;
@property (strong,nonatomic) RestaurantFeed *restaurantFeedSearched;

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *restaurantSearchBar;
@property (nonatomic,assign)BOOL isFiltered;

@end

@implementation RestaurantsViewController

#pragma - mark
#pragma - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< Updated upstream
    [self setDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark
#pragma - Helper methods

-(void)setDefaults{
=======
    // Do any additional setup after loading the view.
    
    _restaurantSearchBar.delegate=self;
    
>>>>>>> Stashed changes
    [self showRightNavigationBarButton];
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

#pragma - mark
#pragma - Search controller methods

<<<<<<< Updated upstream
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [restaurants filteredArrayUsingPredicate:resultPredicate];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

=======
>>>>>>> Stashed changes

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFiltered) {
        return [_restaurantFeedSearched restaurantsCount];
    }
<<<<<<< Updated upstream
    else if([_restaurantFeed restaurantsCount] > 0){
        return [_restaurantFeed restaurantsCount];
    }
    else{
        return 1;
    }
=======
    else
    return [_restaurantFeed restaurantsCount];
    
>>>>>>> Stashed changes
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"RestaurantTableViewCell";
<<<<<<< Updated upstream
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        restaurants = [searchResults objectAtIndex:indexPath.row];
    }
    else if([_restaurantFeed restaurantsCount] > 0){
         RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
=======
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (_isFiltered) {
        [cell populateData:[_restaurantFeedSearched restaurantAtIndex:indexPath.row]];
    }
    else
    {
>>>>>>> Stashed changes
        [cell populateData:[_restaurantFeed restaurantAtIndex:indexPath.row]];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        return cell;
    }
    else if([_restaurantFeed restaurantsCount] == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        return cell;
    }
    
<<<<<<< Updated upstream
    return nil;
=======
    
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    
    return cell;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
>>>>>>> Stashed changes
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MapViewController"]){
        MapViewController *mapViewController=(MapViewController *)segue.destinationViewController;
        mapViewController.meal =(Meal *)sender;
    }
}

#pragma - mark
#pragma - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"Call button was pressed");
            NSString *phoneNumber=@"123";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
            
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
    }
    else
    {
        _isFiltered = true;
        _restaurantFeedSearched = [[RestaurantFeed alloc] init];
        
        
        for (Restaurant* restaurant in _restaurantFeed.restaurantFeed)
        {
            NSRange nameRange = [restaurant.storeName rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound)
            {
                [_restaurantFeedSearched.restaurantFeed addObject:restaurant];
            }
        }
    }
    
    [self.restaurantTableView reloadData];
}

@end
