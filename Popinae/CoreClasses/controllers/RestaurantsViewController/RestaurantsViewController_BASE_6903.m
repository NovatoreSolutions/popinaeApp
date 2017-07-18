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


@interface RestaurantsViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (strong,nonatomic) RestaurantFeed *restaurantFeed;

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;

@end

@implementation RestaurantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else
        return [_restaurantFeed restaurantsCount];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"RestaurantTableViewCell";
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        restaurants = [searchResults objectAtIndex:indexPath.row];
        
    } else {
        
        [cell populateData:[_restaurantFeed restaurantAtIndex:indexPath.row]];
    }
    
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    
    return cell;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"MapViewController"]){
        MapViewController *mapViewController=(MapViewController *)segue.destinationViewController;
        mapViewController.meal =(Meal *)sender;
    }

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


#pragma mark - SWTableViewDelegate


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



@end
