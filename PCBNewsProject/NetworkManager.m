//
//  NetworkManager.m
//  PCBNewsProject
//
//  Created by pawanag on 4/17/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking/AFHTTPRequestOperation.h"
#import "NewsModelClass.h"
#import "NewsParserClass.h"



//UAT
//static NSString * const urlStringGetNewsDetails = @"http://pcbqa.pcbtoday.in/Api/index/getNewsDetails";
//
//static NSString * const urlStringGetNewsList = @"http://pcbqa.pcbtoday.in/api/index/getNewsList";
//
//
//static NSString * const LandingPageNewsURLString = @"http://pcbqa.pcbtoday.in/Api/index/dashboard";



//PROD
static NSString * const urlStringGetNewsDetails = @"http://pcbtoday.in/Api/index/getNewsDetails";

static NSString * const urlStringGetNewsList = @"http://pcbtoday.in/api/index/getNewsList";


static NSString * const LandingPageNewsURLString = @"http://pcbtoday.in/Api/index/dashboard";


@interface NetworkManager()

@property (nonatomic,strong) NewsParserClass *newsParserClass;

@end

@implementation NetworkManager

-(NewsParserClass*) newsParserClass {
    
    if (!_newsParserClass) {
        _newsParserClass = [[NewsParserClass alloc]init];
    }
    return _newsParserClass;
}

-(void) initNetworkManager {
    
}

-(void) getArrayOfBannerNews : (NSString*)string  withSuccess : (void (^) (BOOL success, NSMutableArray* arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure
{
    
    __block NetworkManager *blockSelf = self;
    
    NSString *partnerSecretKey= @"PCB_SAMAR";
    NSString *landingPageURLString = [NSString stringWithFormat:@"partnerSecretKey=%@",partnerSecretKey];
    
    NSURL * url = [NSURL URLWithString:LandingPageNewsURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[landingPageURLString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"responseObject->%@",responseObject);
        
        [blockSelf.newsParserClass parseResponseReturned:responseObject withCallBack:^(NSMutableArray *arrayOfNews)
         {
            success(true, arrayOfNews);
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(true, error);
    }];
    
    [operation start];
    
}

-(void) getArrayNewsList:(NSString*)newsId limit: (NSString*)limit start : (NSString*)start collection_id : (NSString*)collection_id  withSuccess : (void (^) (BOOL success, NSMutableArray * arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure  {
    
    NSString *LocationBasedNewsUrlString;
    NSString *partnerSecretKey= @"PCB_SAMAR";
        
    LocationBasedNewsUrlString = [NSString stringWithFormat:@"partnerSecretKey=%@&newsTypeId=%@&limit=%@&start=%@&id=%@",partnerSecretKey,newsId,limit,start,collection_id];
        
    NSURL *url = [NSURL URLWithString:urlStringGetNewsList];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"URL Of Webservice call is %@", url);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[LocationBasedNewsUrlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    __block NetworkManager *blockSelf = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [blockSelf.newsParserClass parseNewsListResponseReturned:responseObject withCallBack:^(NSMutableArray *arrayOfNews) {
            
             
            if (arrayOfNews.count> 0)
            {
                
            }
            
            success(true, arrayOfNews);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(true, error);
    }];
    
    [operation start];
}


-(void) getArrayOfLocationBasedNewsFromNotification : (NSString*)name withNewsId : (NSString*)newsId  withSuccess : (void (^) (BOOL success, NSMutableArray * arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure  {
    
    NSString *LocationBasedNewsUrlString;
    
    if (newsId) {
        
        NSString *partnerSecretKey= @"PCB_SAMAR";
        
        LocationBasedNewsUrlString = [NSString stringWithFormat:@"partnerSecretKey=%@&newsId=%@ ",partnerSecretKey,newsId];
        
    } else
    {
        LocationBasedNewsUrlString = [NSString stringWithFormat:@"%@%@?tag=first", urlStringGetNewsDetails, name];
    }
    
    
    NSURL *url = [NSURL URLWithString:urlStringGetNewsDetails];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"URL Of Webservice call is %@", url);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[LocationBasedNewsUrlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    __block NetworkManager *blockSelf = self;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [blockSelf.newsParserClass parseResponseReturnedForNotifiction:responseObject withCallBack:^(NSMutableArray *arrayOfNews) {
                       
            success(true, arrayOfNews);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(true, error);
    }];
    
    [operation start];
}



-(void) getArrayOfLocationBasedNewsWithLocationName : (NSString*)name withNewsId : (NSString*)newsId  withSuccess : (void (^) (BOOL success, NSMutableArray * arrayOfNews ))success withFailure :(void (^) (BOOL failure , NSError * error )) failure  {
    
    NSString *LocationBasedNewsUrlString;
    
    if (newsId) {
 
        NSString *partnerSecretKey= @"PCB_SAMAR";
        
         LocationBasedNewsUrlString = [NSString stringWithFormat:@"partnerSecretKey=%@&newsId=%@ ",partnerSecretKey,newsId];
        
    } else
    {
        LocationBasedNewsUrlString = [NSString stringWithFormat:@"%@%@?tag=first", urlStringGetNewsDetails, name];
    }
   

    NSURL *url = [NSURL URLWithString:urlStringGetNewsDetails];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"URL Of Webservice call is %@", url);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[LocationBasedNewsUrlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    __block NetworkManager *blockSelf = self;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [blockSelf.newsParserClass parseResponseReturned:responseObject withCallBack:^(NSMutableArray *arrayOfNews) {
            if (arrayOfNews.count> 0)
            {
                 [arrayOfNews removeObjectAtIndex:0];
            }
           
            success(true, arrayOfNews);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(true, error);
    }];
    
    [operation start];
}

@end
