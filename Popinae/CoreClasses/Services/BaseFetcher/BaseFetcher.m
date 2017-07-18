//
//  BaseFetcher.m
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseFetcher.h"
#import <AFNetworking.h>
#import "Constant.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface BaseFetcher(){
    AFHTTPRequestOperationManager *manager;
    AFHTTPRequestOperation *operation ;
    
}


@end
@implementation BaseFetcher
- (void)fetchJsonResponseWithJsonRequestURL:(NSString *)urlString withMethodType:(MethodType)methodType HTTPBody:(id)params completionBlock:(BaseFetcherCompletionHandler)handler{
    
    if (!manager) {
        
            // make manger object
        manager  = [[AFHTTPRequestOperationManager alloc] init];
        
    }
        // make request
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer = serializer;
    

    
        // make response
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer = responseSerializer;
    
    
    if (methodType == METHOD_POST) {
        
        
        operation =[manager POST:urlString parameters:params constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            handler(nil,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            handler(error,nil);
        }];
        
        
    }
    
    if (methodType == METHOD_GET) {
            // call opertaion
        operation =[manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handler(nil,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handler(error,nil);
            
        }];
        
    }
    
        // opetation start

    [operation start];
}




- (void)fetchJsonResponseWithHTTPRequestURL:(NSString *)urlString withMethodType:(MethodType)methodType HTTPBody:(id)params completionBlock:(BaseFetcherCompletionHandler)handler{
    
    
    if (!manager) {
        
            // make manger object
        manager  = [[AFHTTPRequestOperationManager alloc] init];
        
    }
    
        // make request
                AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
//    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        //    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
        //    [serializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    manager.requestSerializer = serializer;
    
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
        // make response
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = responseSerializer;
    
    
    
    if (methodType == METHOD_POST) {
        
        
        operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            handler(nil,responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handler(error,nil);
        }];
        
        
        
        
    }
    
    if (methodType == METHOD_GET) {
            // call opertaion
        operation =[manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handler(nil,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handler(error,nil);
            
        }];
        
    }
    
        // opetation start
    [operation start];
}








- (void)fetchHTTPResponseWithHTTPRequestURL:(NSString *)urlString withMethodType:(MethodType)methodType HTTPBody:(id)params completionBlock:(BaseFetcherCompletionHandler)handler{
    
    
    if (!manager) {
        
            // make manger object
        manager  = [[AFHTTPRequestOperationManager alloc] init];
        
    }
    
        // make request
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        //    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer = serializer;
   
    
        // make response
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    
    
    
    
    if (methodType == METHOD_POST) {
        
        
        operation =[manager POST:urlString parameters:params constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handler(nil,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handler(error,nil);
            
        }];
        
        
    }
    
    if (methodType == METHOD_GET) {
            // call opertaion
        operation =[manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handler(nil,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handler(error,nil);
            
        }];
        
    }
    
        // opetation start
    [operation start];
}



-(void)cancelRequest{
    [manager.operationQueue cancelAllOperations];
}




@end
