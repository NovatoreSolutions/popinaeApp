//
//  BaseParser.m
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "BaseParser.h"
#import "Constant.h"
#import "NSDictionary+ObjectWithKey.h"
@interface BaseParser()

@end


@implementation BaseParser

- (void)parseData:(id)serverData withCompletionHandler:(BaseParserCompletionHandler)handler {

    NSDictionary *dict = (NSDictionary *)serverData;
//    NSString *successStatus = [dict objectForKey:kStatus];
//    
//    if ([successStatus isEqualToString:@"success"]) {
//        
//        NSString *message;
//        
//        if ([dict objectForKey:kMessage]) {
//            
//            message  =(NSString*) [dict objectForKey:kMessage];
//        } else {
//            message = @"";
//            NSLog(@"no server message availble");
//        }
//        
//            handler (nil,message,dict);
//    }
//    else {
//        
//        NSMutableDictionary* details = [NSMutableDictionary dictionary];
//        [details setValue:[dict objectForKey:kMessage] forKey:NSLocalizedDescriptionKey];
//        
//        NSError *error = [[NSError alloc] initWithDomain:@"Network Call Failure" code:200 userInfo:details];
//        
//        NSString *message;
//            
//        message  =(NSString*) [dict objectForKey:kMessage];
//        
//        handler (error,message,dict);
//    }

     NSString *message = nil;
        message  =(NSString*) [dict objectWithKey:kMessage];

    
    id data = [dict objectForKey:kData];
    
          handler (nil,message,data);
    
}



@end
