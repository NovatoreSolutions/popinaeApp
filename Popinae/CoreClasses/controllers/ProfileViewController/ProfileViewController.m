//
//  ProfileViewController.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCellHeader.h"
#import "ProfileTableViewCell.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>


@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ProfileTableViewCell* profileCell;
}

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return 3;
    else if(section==1)
        return 1;
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
    User *user=[User sharedUser];
    
    if(indexPath.section==0){
        
        if(indexPath.row==0){
            if([user.userName isEqual:@""]|| user.userName == nil){
                [profileCell populateDataWithTitle:@"Name" Value:@"Not Available"];
            }else{
                [profileCell populateDataWithTitle:@"Name" Value:user.userName];
            }
        }
        
        else if (indexPath.row==1){
            if([user.userEmail isEqual:@""] || user.userEmail == nil){
                [profileCell populateDataWithTitle:@"Email" Value:@"Not Available"];
            }else{
                [profileCell populateDataWithTitle:@"Email" Value:user.userEmail];
            }
        }
        else if (indexPath.row==2){
            if([user.userPhone isEqual:@""] || user.userPhone == nil){
                [profileCell populateDataWithTitle:@"Phone" Value:@"Not Available"];
            }else{
                [profileCell populateDataWithTitle:@"Phone" Value:user.userPhone];
            }
        }
    }
    else if (indexPath.section==1)
    {
        [profileCell populateDataWithTitle:@"Radius" Value:@"5 Km"];
    }
    return profileCell;
}


#pragma - mark
#pragma - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        
        
    }
    else if (indexPath.section==1){
        
        NSArray *distance = [NSArray arrayWithObjects:@"5 Km", @"10 Km", @"50 Km",@"All", nil];
        
        [ActionSheetStringPicker showPickerWithTitle:@"Select a Radius"
                                                rows:distance
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               NSLog(@"Picker: %@", picker);
                                               NSLog(@"Selected Index: %ld", (long)selectedIndex);
                                               NSLog(@"Selected Value: %@", selectedValue);
                                               [profileCell populateDataWithTitle:@"Radius" Value:selectedValue];
                                               
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             NSLog(@"Block Picker Canceled");
                                         }
                                              origin:self.view];
        
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        return [ProfileTableViewCellHeader profileTableViewCellHeader:@"PERSONAL INFO"];
        
    }
    else if (section==1){
        return [ProfileTableViewCellHeader profileTableViewCellHeader:@"GEO SETTINGS"];
    }
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 49.0f;
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




@end
