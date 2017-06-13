//
//  NetworkManager.h
//  PCBNewsProject
//
//  Created by pawanag on 4/17/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetworkManager;


@interface NetworkManager : NSObject

-(void) initNetworkManager;

//-(void) getArrayOfBannerNews : (NSString*)string  withCompletionBlock : (void (^) (BOOL success, BOOL failure , NSArray * arrayOfNews )) completionBlock;

-(void) getArrayOfBannerNews : (NSString*)string  withSuccess : (void (^) (BOOL success, NSMutableArray * arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure ;

-(void) getArrayOfLocationBasedNewsWithLocationName : (NSString*)name withNewsId : (NSString*)newsId  withSuccess : (void (^) (BOOL success, NSMutableArray * arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure ;

-(void) getArrayNewsList:(NSString*)newsId limit : (NSString*)limit start : (NSString*)start collection_id : (NSString*)collection_id  withSuccess : (void (^) (BOOL success, NSMutableArray * arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure;

-(void) getArrayOfLocationBasedNewsFromNotification : (NSString*)name withNewsId : (NSString*)newsId  withSuccess : (void (^) (BOOL success, NSMutableArray * arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure;

//-(void) getImagesForBannerNews : (NSString*)string  withSuccess : (void (^) (BOOL success, NSData * data ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure ;

@end
