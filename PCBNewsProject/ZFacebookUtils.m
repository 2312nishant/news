//
//  ZFacebookUtils.m
//  PCBNewsProject
//
//  Created by pawanag on 8/2/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "ZFacebookUtils.h"
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>


@interface ZFacebookUtils ()

@property (nonatomic,copy) ZBooleanResultBlock loginBlock;
@property (nonatomic,copy) NSString *appID;
@property (nonatomic, strong) FBSDKLoginManager *login;
@end

@implementation ZFacebookUtils

+ (ZFacebookUtils *)instance
{
    static dispatch_once_t pred = 0;
    __strong static ZFacebookUtils *_sharedInstance = nil;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)logInWithBlock:(ZBooleanResultBlock)block
{
    self.loginBlock = [block copy];
    self.isLastOpenService = YES;
    _login = [[FBSDKLoginManager alloc] init];
    [_login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        self.isLastOpenService = NO;
        if (error) {
            [self didFinishAuthrizationWithError:error];
        } else if (result.isCancelled) {
            NSError *error;
            [self didFinishAuthrizationWithError:error];
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                [self didFinishAuthrizationWithError:nil];
            }
        }
    }];
}


- (void)didFinishAuthrizationWithError:(NSError *)error
{
    if (self.loginBlock) {
        (nil != error)  ? self.loginBlock(NO,error) : self.loginBlock (YES,error);
    }
}
/*
 NSError *error = [NSError errorWithDescription:@"Facebook login unsuccessful"];
 [self didFinishAuthrizationWithError:error];
 */
+ (void)showFacebookAlertForError:(NSError *)error
{
}

+ (void)showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle
{

    [[[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
}

- (void)logout
{
    [_login logOut];
}


#pragma mark - Permissions And Permission handling

- (NSString *)accessToken
{
    return [[FBSDKAccessToken currentAccessToken] tokenString];
}
@end
