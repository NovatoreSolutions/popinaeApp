//
//  NSMutableDictionary+SetObjectWithKey.m
//  Popinae
//
//  Created by AMK on 07/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "NSMutableDictionary+SetObjectWithKey.h"

@implementation NSMutableDictionary (SetObjectWithKey)

- (void)setObject:(id)anObject WithKey:(id <NSCopying>)aKey{
    
    if (anObject != nil) {
        [self setObject:anObject forKey:aKey];
        
    }else{
        [self setObject:[NSNull null] forKey:aKey];
    }
    
}
@end
