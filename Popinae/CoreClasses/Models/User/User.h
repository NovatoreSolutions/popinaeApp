//
//  User.h
//  Popinae
//
//  Created by Jamshaid on 02/02/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef void(^LoginCompletionHandler) (NSError* error);
typedef void(^SignupCompletionHandler) (NSError* error);

@interface User : BaseModel<NSCoding>

@property (readonly,strong,nonatomic) NSString* userId;
@property (readonly,strong,nonatomic) NSString* userName;
@property (readonly,strong,nonatomic) NSString* userToken;
@property (readonly,strong,nonatomic) NSString* userEmail;
@property (readonly,strong,nonatomic) NSString* userPhone;
@property (readonly,strong,nonatomic) NSString* userPassword;

// to get shared user instance
+(User*)sharedUser;

// to get shared user instance saved in NSUserDefaults, if does't exist than returns nil
+(User*)sharedUserFromUserDefaults;

// to save/update shared user instance in NSUserDefaults
+(void)saveSharedUserInUserDefaults;

// asking user to request server to login and on success filled its properties with server response

-(void)loginWithUsername:(NSString*)username // email
                password:(NSString*)password // password
       completionHandler:(LoginCompletionHandler)handler;

// asking user to request server to register and on success filled its properties with server response

-(void)signupWithName:(NSString*)name     // user full name
                email:(NSString*)email    // user email id
                phone:(NSString*)phone    // user phone
             password:(NSString*)password // user password
    completionHandler:(SignupCompletionHandler)handler;

// this method returns true if user has a token and it is not expired
// this method should be called before asking user to login

-(BOOL)isUserTokenValid;

@end













