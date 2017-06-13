//
//  InsertIntodatabseOperation.h
//  PCBNewsProject
//
//  Created by pawanag on 6/22/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface InsertIntodatabseOperation : NSOperation

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(id) initOperationWithBannerNewsArray : (NSArray*)bannerNewsArray ;
@end
