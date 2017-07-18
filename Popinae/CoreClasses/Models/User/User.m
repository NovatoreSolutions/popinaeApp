//
//  User.m
//  Popinae
//
//  Created by Jamshaid on 02/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "User.h"
#import "BaseFetcher.h"
#import "BaseParser.h"
#import "Constant.h"
#import "NSDictionary+ObjectWithKey.h"

@interface User()

@property (strong,nonatomic) NSNumber* userLoginTimeStamp;// marked when user gets a new token

@end

static User* _sharedInstance = nil;

@implementation User

+(User*)sharedUser{
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ _sharedInstance = [[User alloc]initSharedInstance];});
    return _sharedInstance;
}
-(id)initSharedInstance{
    
    self = [super init];
    if (self)
    {
        _userId             = nil;
        _userName           = nil;
        _userToken          = nil;
        _userEmail          = nil;
        _userPhone          = nil;
        _userPassword       = nil;
        _userLoginTimeStamp = nil;
    }
    return self;
}
-(id)init{
    
    NSAssert(_sharedInstance == nil,USER_ERROR_SINGLETON);
    NSAssert(_sharedInstance != nil,USER_ERROR_SINGLETON);
    return nil;
}

#pragma - mark
#pragma - NSUserDefaults related methods

+(User*)sharedUserFromUserDefaults{
    _sharedInstance = nil;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = (NSData*)[userDefaults objectForKey:USER_DEFAULTS_KEY];
    if (userData) {
        _sharedInstance = (User*)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    return _sharedInstance;
}
+(void)saveSharedUserInUserDefaults{
    if (_sharedInstance == nil) {
        return;
    }
    NSData* userData = [NSKeyedArchiver archivedDataWithRootObject:_sharedInstance];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userData forKey:USER_DEFAULTS_KEY];
    [userDefaults synchronize];
}

#pragma - mark
#pragma - NSCoding protocol methods

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (!self) {
        return nil;
    }
    _userId             = [aDecoder decodeObjectForKey:kUserID];
    _userName           = [aDecoder decodeObjectForKey:kUserName];
    _userToken          = [aDecoder decodeObjectForKey:kUserToken];
    _userEmail          = [aDecoder decodeObjectForKey:kUserEmail];
    _userPhone          = [aDecoder decodeObjectForKey:kUserPhone];
    _userPassword       = [aDecoder decodeObjectForKey:kUserPassword];
    _userLoginTimeStamp = [aDecoder decodeObjectForKey:kUserLoginTimeStamp];
    
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_userId             forKey:kUserID];
    [aCoder encodeObject:_userName           forKey:kUserName];
    [aCoder encodeObject:_userToken          forKey:kUserToken];
    [aCoder encodeObject:_userEmail          forKey:kUserEmail];
    [aCoder encodeObject:_userPhone          forKey:kUserPhone];
    [aCoder encodeObject:_userPassword       forKey:kUserPassword];
    [aCoder encodeObject:_userLoginTimeStamp forKey:kUserLoginTimeStamp];
}

#pragma - mark
#pragma - API related methods

-(void)loginWithUsername:(NSString*)username
                password:(NSString*)password
       completionHandler:(LoginCompletionHandler)handler{

    NSString *stringURL  = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kLoginURL];
    
    NSDictionary *httpBody = nil;
    httpBody = @{kUserLoginKey:username,kUserPasswordKey:password};
    
    BaseFetcher *fetcher = [[BaseFetcher alloc] init];
    
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_POST HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        
        if (error == nil) {
            
            BaseParser *parser = [[BaseParser alloc] init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
                
                // saving password, login time stamp
                _userLoginTimeStamp = [self getTimeStamp];
                _userPassword = password;
                
                // saving other properties
                [self populateData:dataObject withServerMessage:serverMsg];
                handler (error); // informing caller about success
            }];
            
        }else{
            
            handler (error); // informing caller about failure
        }
    }];
}

-(void)signupWithName:(NSString*)name
                email:(NSString*)email
                phone:(NSString*)phone
             password:(NSString*)password
    completionHandler:(SignupCompletionHandler)handler{
    
    NSString* stringURL = nil;
    stringURL = [NSString stringWithFormat:@"%@%@",BASE_URL,kSignupURL];
    
    NSDictionary* httpBody = nil;
    httpBody = @{kUserSignupNameKey:name,kUserSignupEmailKey:email,kUserSignupPhoneKey:phone,kUserSignupPasswordKey:password};
    
    BaseFetcher* fetcher = [[BaseFetcher alloc]init];
    [fetcher fetchJsonResponseWithHTTPRequestURL:stringURL withMethodType:METHOD_POST HTTPBody:httpBody completionBlock:^(NSError *error, id responseObject) {
        if (error == nil) {
            
            BaseParser* parser = [[BaseParser alloc]init];
            [parser parseData:responseObject withCompletionHandler:^(NSError *error, NSString *serverMsg, id dataObject) {
                
                // saving password, login time stamp
                _userLoginTimeStamp = [self getTimeStamp];
                _userPassword = password;
                
                // saving other properties
                [self populateData:dataObject withServerMessage:serverMsg];
                handler (error); // informing caller about success
            }];
            
        }else{
            
            handler(error); // informing caller about failure
        }
    }];
}

-(BOOL)isUserTokenValid{
    if (_userToken == nil || _userLoginTimeStamp == nil) {
        return NO;
    }
    
    NSNumber* newTimeStamp = [self getTimeStamp];
    
    int validTokenDurationInSeconds = 3600;
    
    NSInteger timeWhenTokenExpires = [_userLoginTimeStamp integerValue] + validTokenDurationInSeconds;
    NSInteger currentTime = [newTimeStamp integerValue];
    
    if (currentTime < timeWhenTokenExpires) {
        return YES; // token not expired
    }else{
        return NO; // token expired
    }
}

#pragma - mark
#pragma - Helper methods

-(void)populateData:(id)data withServerMessage:(NSString*)serverMessage {
    
    NSDictionary* dataDict = (NSDictionary*)data;
    _userId       = [dataDict objectWithKey:kUserID];
    _userName     = [dataDict objectWithKey:kUserName];
    _userToken    = [dataDict objectWithKey:kUserToken];
    _userEmail    = [dataDict objectWithKey:kUserEmail];
    _userPhone    = [dataDict objectWithKey:kUserPhone];
}

-(NSNumber*)getTimeStamp{
    NSNumber* timeStamp = nil;
    NSInteger secondsSince1970 = lround([[NSDate date] timeIntervalSince1970]);
    timeStamp = [NSNumber numberWithInteger:secondsSince1970];
    return timeStamp;
}

#pragma - mark
#pragma - overridden methods

-(NSString*)description{
    NSString* description = [NSString stringWithFormat:@"\n user id = %@ \n user name = %@ \n user token = %@ \n user email = %@ \n user phone = %@ \n user password = %@",_userId,_userName,_userToken,_userEmail,_userPhone,_userPassword];
    return description;
}

@end
