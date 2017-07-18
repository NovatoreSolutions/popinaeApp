//
//  TableViewCustomHeader.h
//  Popinae
//
//  Created by Jamshaid on 31/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCustomHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblOrderTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderPrice;

+(id)tableViewCustomHeader; // to get an instance of this class

@end
