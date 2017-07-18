//
//  BaseService.h
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseFetcher.h"

@interface BaseService : NSObject



@property (strong, nonatomic) BaseFetcher *fetcher;
-(void)cancelRequest;
@end
