//
//  ZFacebookUtils.h
//  PCBNewsProject
//
//  Created by pawanag on 8/2/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ZBooleanResultBlock)(BOOL success, NSError *error);
@interface ZFacebookUtils : NSObject

- (NSString *)appID;
@property (nonatomic) NSString *accessToken;
//set it YES before facebook app or browser app open in authentication
// need it for openurl in applicationdelegate
@property (nonatomic, assign) BOOL isLastOpenService;
/*!
 
 //Fetched client
 @result The Facebook instance.
 
 */
+ (ZFacebookUtils *)instance;

- (void)logInWithBlock:(ZBooleanResultBlock)block;

+ (void)showFacebookAlertForError:(NSError *)error;

/*
 @abstract
 logout and clear token
 */
- (void)logout;
@end
