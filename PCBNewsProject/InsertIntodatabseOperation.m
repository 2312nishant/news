//
//  InsertIntodatabseOperation.m
//  PCBNewsProject
//
//  Created by pawanag on 6/22/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "InsertIntodatabseOperation.h"
#import "AppDelegate.h"
#import "NewsModelClass.h"
#import "BannerNews.h"
#import "Constants.h"


@interface InsertIntodatabseOperation ()

@property (nonatomic,strong) BannerNews *bannerNewsObject;
@property (nonatomic,strong) NSArray *bannerNewsArray;
@end

@implementation InsertIntodatabseOperation

-(NSManagedObjectContext*)managedObjectContext {
    
    if(!_managedObjectContext) {
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
    }
    return _managedObjectContext;
}

-(id) initOperation {
    if (![super init]){
        
        return nil;
        
    } else {
        self = [super init];
        return self;
    
    }
}
-(id) initOperationWithBannerNewsArray : (NSArray*)bannerNewsArray {
    if (![super init]){
        return nil;
    } else {
        self = [super init];
       
        self.bannerNewsArray = bannerNewsArray;
         return self;
    }
    return self;
}

-(void)main {
    
    for (NewsModelClass *newsclassObject in self.bannerNewsArray) {
        self.bannerNewsObject  = [NSEntityDescription insertNewObjectForEntityForName:kBannerNewsEntity inManagedObjectContext:self.managedObjectContext];
        
        if ( ![[NSNull null] isEqual: newsclassObject.newsId] ) {
             self.bannerNewsObject.id = newsclassObject.newsId;
        }
        if (newsclassObject.newsTitle) {
            self.bannerNewsObject.title = newsclassObject.newsTitle;
        }
        if (![[NSNull null] isEqual: newsclassObject.newsDate]) {
            self.bannerNewsObject.date = newsclassObject.newsDate;
        }
        if (![[NSNull null] isEqual:newsclassObject.newsImageUrl]) {
            self.bannerNewsObject.images = newsclassObject.newsImageUrl;
        }
        if (newsclassObject.newsDescription) {
            self.bannerNewsObject.newsDescription = newsclassObject.newsDescription;
        }
        if (newsclassObject.NewsPage_newsdetails) {
            self.bannerNewsObject.page_newsdetails = newsclassObject.NewsPage_newsdetails;
        }
        if (newsclassObject.newsTagdesc) {
            self.bannerNewsObject.tagdesc = newsclassObject.newsTagdesc;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        
        [self.managedObjectContext save:&error];
        if ([self.managedObjectContext save:&error]) {
//            NSLog(@"data saved Successfully");
            
        }
        
    });
    
}

@end
