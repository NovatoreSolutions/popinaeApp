//
//  NSMutableDictionary+SetObjectWithKey.h
//  Popinae
//
//  Created by AMK on 07/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SetObjectWithKey)
- (void)setObject:(id)anObject WithKey:(id <NSCopying>)aKey;

@end
