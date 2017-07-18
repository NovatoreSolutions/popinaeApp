//
//  BaseService.m
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseService.h"
@interface BaseService(){
    
}

@end
@implementation BaseService
-(id)init{
    self = [super init ];
    
    if (self) {
        self.fetcher = [[BaseFetcher  alloc] init];
    }
    return self;
}

-(void)cancelRequest{
    
    [_fetcher cancelRequest];
    
    
}

@end
