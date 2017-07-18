//
//  NSDictionary+ObjectWithKey.m
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "NSDictionary+ObjectWithKey.h"

@implementation NSDictionary (ObjectWithKey)

-(id)objectWithKey:(NSString*)string{
    
    
    id object = nil;
    
    if ([self objectForKey:string] != [NSNull null]) {
        
        object =   [self objectForKey:string];
    }
    
    return object;
}
@end
