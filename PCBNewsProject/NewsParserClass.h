//
//  NewsParserClass.h
//  PCBNewsProject
//
//  Created by pawanag on 4/28/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsParserClass : NSObject

-(void) parseResponseReturned : (id) responseObject withCallBack : (void (^) ( NSMutableArray * arrayOfNews) )completionHandler;

-(void) parseResponseReturnedFromDataBase : (id) responseObject withCallBack : (void (^) ( NSMutableArray * arrayOfNews) )completionHandler;

-(void) parseNewsListResponseReturned : (id) responseObject withCallBack : (void (^) ( NSMutableArray * arrayOfNews) )completionHandler;

-(void) parseResponseReturnedForNotifiction : (id) responseObject withCallBack : (void (^) ( NSMutableArray * arrayOfNews) )completionHandler;

@end
