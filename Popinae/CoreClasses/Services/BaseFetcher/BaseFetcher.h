//
//  BaseFetcher.h
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    METHOD_GET,
    METHOD_POST
} MethodType;
typedef void (^BaseFetcherCompletionHandler)(NSError *error,id responseObject);
//typedef void (^ShowProgressHandler)(CGFloat progress);



@interface BaseFetcher : NSObject


- (void)fetchJsonResponseWithHTTPRequestURL:(NSString *)urlString withMethodType:(MethodType)methodType HTTPBody:(id)params completionBlock:(BaseFetcherCompletionHandler)handler;

- (void)fetchJsonResponseWithJsonRequestURL:(NSString *)urlString withMethodType:(MethodType)methodType HTTPBody:(id)params completionBlock:(BaseFetcherCompletionHandler)handler;

- (void)fetchHTTPResponseWithHTTPRequestURL:(NSString *)urlString withMethodType:(MethodType)methodType HTTPBody:(id)params completionBlock:(BaseFetcherCompletionHandler)handler;

- (void)cancelRequest;
@end
