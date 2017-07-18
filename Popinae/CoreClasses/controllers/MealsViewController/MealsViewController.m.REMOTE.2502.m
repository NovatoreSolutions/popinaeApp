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

@interface MealsViewController ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
@property (strong,nonatomic) MealFeed *mealFeed;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self showRightNavigationBarButton];
    
    
    [self callService];
}

-(void)callService{
    
    
    [self showActivityIndicator];
    
    if (_mealFeed == nil) {
        _mealFeed = [MealFeed sharedMealFeed];
    
    }
    
    
    AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
   // [delegate.location startUpdatingLocation];
    CLLocation *location = [delegate.location location];
    
    
    CLLocationCoordinate2D coord;
    coord.longitude = location.coordinate.longitude;
    coord.latitude = location.coordinate.latitude;
    NSLog(@"Latitude = %f , Longitude =%f",coord.latitude,coord.longitude);
   // [delegate.location stopUpdatingLocation];
    
//    [_mealFeed getMealsWithLatitude:coord.latitude longitude:coord.longitude radius:5.0f keyword:nil pageNo:1 recordsNo:1 completionHandler:^(NSError *error) {
//        [self hideActivityIndicator];
//        if (!error) {
//            
//            
//            [_tableView reloadData];
//        }else {
//            
//        }
//    }];
//    

    
    
    
    [_mealFeed getMealsWithMealId:nil mealFamilyId:nil storeId:nil sortBy:@"mealId" sortOrder:@"desc" pageNo:[NSNumber numberWithInt:1] recordsNo:[NSNumber numberWithInt:1] lang:nil completionHandler:^(NSError *error) {
    
    
        [self hideActivityIndicator];
        if (!error) {
            
            
            [_tableView reloadData];
        }else {
            
        }
    }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [meals filteredArrayUsingPredicate:resultPredicate];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"MealDetailsViewController"]) {
        
        MealDetailsViewController *mealDetailsViewController = (MealDetailsViewController*)segue.destinationViewController;
        mealDetailsViewController.meal = (Meal*)sender;
    }
    else if ([segue.identifier isEqualToString:@"MapViewController"]){
        
        MapViewController *mapViewController=(MapViewController *)segue.destinationViewController;
        mapViewController.meal =(Meal *)sender;
        
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else
        return [_mealFeed mealsCount];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"MealsTableViewCell";
    MealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        meals = [searchResults objectAtIndex:indexPath.row];
        
    } else {
        
        [cell populateData:[_mealFeed mealAtIndex:indexPath.row]];
    }

    
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:63.0f];
    cell.delegate = self;
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self performSegueWithIdentifier:@"MealDetailsViewController" sender:[_mealFeed mealAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                                                title:@"Order"];
    
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
            
            NSIndexPath *cellIndexPath=[self.tableView indexPathForCell:cell];
            
            [self performSegueWithIdentifier:@"MapViewController" sender:[_mealFeed mealAtIndex:cellIndexPath.row]];
            
           // MapViewController *mapView =[Utility getViewControllerWithStoryboardId:@"MapViewController"];
           // mapView.lat =[_mealFeed mealAtIndex:cellIndexPath.row].storeLat;
          //  mapView.lng =[_mealFeed mealAtIndex:cellIndexPath.row].storeLng;
            
            
            //[self.navigationController pushViewController:mapView animated:YES];
            [cell hideUtilityButtonsAnimated:YES];
            

            break;
        }
        case 2:
        {
            Meal *meal =  [_mealFeed mealAtIndex:0];
            Order* order = [Order sharedOrder];
            if ([order isThisMealAlreadyAdded:meal]) {
                [Utility showAlertWithTitle:@"Meal Alerady in Cart" message:@"You Have Already Add This Meal To Cart !"];
            }else{
               [order addNewMealInOrder:meal];
                [self performSegueWithIdentifier:@"CartViewController" sender:nil];
            }
            
            break;
        }
            
            
        default:
            break;
    }
}

@end
