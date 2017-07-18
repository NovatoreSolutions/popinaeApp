//
//  BaseParser.h
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^BaseParserCompletionHandler)(NSError *error,NSString *serverMsg,id dataObject);

@interface BaseParser : NSObject


- (void)parseData:(id)serverData withCompletionHandler:(BaseParserCompletionHandler)handler ;
@end

