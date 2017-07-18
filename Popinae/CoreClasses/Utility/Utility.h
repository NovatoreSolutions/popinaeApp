//
//  Utility.h
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(id)getViewControllerWithStoryboardId:(NSString *)viewControllerName;
+(BOOL)isValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter;
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
+(void)callNumber:(NSString *)number;

@end
