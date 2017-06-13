//
//  DataBasemanager.m
//  PCBNewsProject
//
//  Created by pawanag on 4/27/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "DataBasemanager.h"
#import "AppDelegate.h"
#import "NewsModelClass.h"
#import "BannerNews.h"
#import "Constants.h"
#import "InsertIntodatabseOperation.h"

@interface DataBasemanager()

@property (nonatomic,strong) BannerNews *bannerNewsObject;
@property (nonatomic,strong) NSOperationQueue *queue;
@end


@implementation DataBasemanager

-(NSOperationQueue*)queue {
    
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

-(NSManagedObjectContext*)managedObjectContext {
    
    if(!_managedObjectContext) {
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
    }
    return _managedObjectContext;
}

-(void) insertBanernewsDataIntoCoreData:(NSArray*) bannerNewsArray {
    
    InsertIntodatabseOperation *insertOperation = [[InsertIntodatabseOperation alloc]initOperationWithBannerNewsArray:bannerNewsArray];
    [self.queue addOperation:insertOperation];
    
}

-(void) deleteBanernewsDataFromCoreDatawithSuccess:(void(^) (BOOL success)) success withFailure : (void (^)(BOOL failure)) failure {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kBannerNewsEntity inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [_managedObjectContext deleteObject:managedObject];
//        NSLog(@" object deleted");
        
    }
    if (![_managedObjectContext save:&error]) {
//        NSLog(@"Error deleting");
    } else {
        success(true);
    }
    
}


-(void) insertBanernewsDataIntoCoreData:(NSArray*) bannerNewsArray withSuccess:(void(^) (BOOL success)) success withFailure : (void (^)(BOOL failure)) failure {
    
    __block DataBasemanager *weakSelf = self;
    [self deleteBanernewsDataFromCoreDatawithSuccess:^(BOOL successful) {
        if (successful) {
//            NSLog(@"success");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                for (NewsModelClass *newsclassObject in bannerNewsArray) {
                    weakSelf.bannerNewsObject  = [NSEntityDescription insertNewObjectForEntityForName:kBannerNewsEntity inManagedObjectContext:self.managedObjectContext];
                    
                    if (![[NSNull null] isEqual:newsclassObject.newsId] && newsclassObject.newsId) {
                        
                        self.bannerNewsObject.id = newsclassObject.newsId;
                    }
                    if (![[NSNull null] isEqual:newsclassObject.newsTitle] && newsclassObject.newsTitle) {
                       
                        self.bannerNewsObject.title = newsclassObject.newsTitle;
                    }
                    if (![[NSNull null] isEqual:newsclassObject.newsDate] && newsclassObject.newsDate) {
                        
                        self.bannerNewsObject.date = newsclassObject.newsDate;
                    }
                    if (![[NSNull null] isEqual:newsclassObject.newsImageUrl] && newsclassObject.newsImageUrl) {
                        
                        self.bannerNewsObject.images = newsclassObject.newsImageUrl;
                    }
                    if (![[NSNull null] isEqual:newsclassObject.newsDescription] && newsclassObject.newsDescription) {
                        
                        self.bannerNewsObject.newsDescription = newsclassObject.newsDescription;
                    }
                    if (![[NSNull null] isEqual:newsclassObject.NewsPage_newsdetails] && newsclassObject.NewsPage_newsdetails) {
                        
                        self.bannerNewsObject.page_newsdetails = newsclassObject.NewsPage_newsdetails;
                    }
                    if (![[NSNull null] isEqual:newsclassObject.newsTagdesc] && newsclassObject.newsTagdesc) {
                        
                        self.bannerNewsObject.tagdesc = newsclassObject.newsTagdesc;
                    }
                    if (![[NSNull null] isEqual:newsclassObject.image] && newsclassObject.image) {
                       
                        self.bannerNewsObject.image = UIImageJPEGRepresentation(newsclassObject.image, 1.0);
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error;
                    
                    [weakSelf.managedObjectContext save:&error];
                    if ([weakSelf.managedObjectContext save:&error]) {
//                        NSLog(@"data saved Successfully");
                        success(true);
                    }
                });
            });
            
        }
    } withFailure:^(BOOL failure) {
        if (failure) {
//            NSLog(@"failure");
        }
    }];
    
    
    
    
}

@end