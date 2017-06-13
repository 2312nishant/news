//
//  DataBasemanager.h
//  PCBNewsProject
//
//  Created by pawanag on 4/27/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataBasemanager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


-(void) insertBanernewsDataIntoCoreData:(NSArray*) bannerNewsArray withSuccess:(void(^) (BOOL success)) success withFailure : (void (^)(BOOL failure)) failure;


@end
