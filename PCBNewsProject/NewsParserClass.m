//
//  NewsParserClass.m
//  PCBNewsProject
//
//  Created by pawanag on 4/28/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "NewsParserClass.h"
#import "NewsModelClass.h"
#import "Constants.h"
#import "TFHpple.h"
#import "BannerNews.h"
#import "Banner.h"


@implementation NewsParserClass



-(void) parseNewsListResponseReturned:(id) responseObject withCallBack:(void (^) ( NSMutableArray * arrayOfNews))completionHandler  {
    
    NewsModelClass * newsObject;
    
    NSDictionary * dictionary = (NSDictionary *)responseObject;
    
    NSMutableArray * arrayOfNewsObject = [NSMutableArray array];
    
    NSDictionary * data_dictionary = [dictionary objectForKey:@"data"];
    
    NSArray* array_NewsList = [data_dictionary objectForKey:@"newsList"];
    
    for (NSDictionary* dictionary in array_NewsList) {
        
        newsObject = [[NewsModelClass alloc]init];
        
        NSString *title  = [dictionary valueForKey:knewsTitle];
        NSString *Description  = [dictionary valueForKey:knewsDescription];
        
        if ([dictionary valueForKey:knewsnewsType_id]) {
            newsObject.newsId = [dictionary valueForKey:knewsnewsType_id];
        }
        if ([dictionary valueForKey:knewsTitle]!= [NSNull null]) {
            newsObject.newsTitle = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if ([dictionary valueForKey:knewsTitle]!= [NSNull null])
        {
            newsObject.newsTagdesc = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        
        if (![[NSNull null] isEqual:Description])
        {
            newsObject.newsDescription = [self parseHtmlResponse:Description];
        }
        
        newsObject.newsDate = [dictionary valueForKey:knewscreated_date];
        newsObject.newsImageUrl = [dictionary valueForKey:knewsimage];
        newsObject.newsType_id = [dictionary valueForKey:knewsnewsType_id];
        newsObject.collection_id = [dictionary valueForKey:knewscollection_id];
        newsObject.newsDescription = [self parseHtmlResponse:[dictionary valueForKey:knewsDescription]];
        newsObject.newsTitle = [dictionary valueForKey:knewsTitle];
        
        [arrayOfNewsObject addObject:newsObject];
        
    }
    
    completionHandler(arrayOfNewsObject);
}



-(void) parseResponseReturnedForNotifiction : (id) responseObject withCallBack : (void (^) ( NSMutableArray * arrayOfNews) )completionHandler  {
    
    NewsModelClass * newsObject;
    
    NSDictionary * dictionary = (NSDictionary *)responseObject;
    
    NSMutableArray * arrayOfNewsObject = [NSMutableArray array];
    
    NSDictionary * data_dictionary = [dictionary objectForKey:@"data"];
    
    NSDictionary * detail_dictionary = [data_dictionary objectForKey:@"newsDetail"];
        
    newsObject = [[NewsModelClass alloc]init];
    
    NSString *title  = [detail_dictionary valueForKey:knewsTitle];
    
    NSString * Description  = [detail_dictionary valueForKey:knewsDescription];
    
    if ([detail_dictionary valueForKey:knewsId]) {
//        newsObject.newsId = [detail_dictionary valueForKey:knewsId];
        newsObject.newsId = [detail_dictionary valueForKey:pcb_news_id];

        
    }
    
    if ([detail_dictionary valueForKey:pcb_news_id]) {
        newsObject.newsType_id = [detail_dictionary valueForKey:pcb_news_id];
    }

    
    if ([detail_dictionary valueForKey:knewsTitle]!= [NSNull null]) {
        newsObject.newsTitle = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
   
    
    
    if (![[NSNull null] isEqual:Description])
    {
        newsObject.newsDescription = [self parseHtmlResponse:Description];
    }
    
    newsObject.newsDate = [detail_dictionary valueForKey:knewscreated_date];
    newsObject.image = [dictionary valueForKey:knewsimage];
    newsObject.newsImageUrl = [detail_dictionary valueForKey:knewsimage];
    newsObject.collection_id = [detail_dictionary valueForKey:knewsId];
    
    [arrayOfNewsObject addObject:newsObject];
    
    completionHandler(arrayOfNewsObject);
}


-(void) parseResponseReturned : (id) responseObject withCallBack : (void (^) ( NSMutableArray * arrayOfNews) )completionHandler  {
    
    NewsModelClass *newsObject;
    
    //Banner *bannerObject;

    NSDictionary *dictionary = (NSDictionary *)responseObject;
    
    NSLog(@"%@",dictionary);
    
    //NSMutableArray *arrayOfNewsAndBannerObject = [NSMutableArray array];
    
    NSMutableArray *arrayOfNewsObject = [NSMutableArray array];
    //NSMutableArray *arrayOfBannerObject = [NSMutableArray array];
    
    NSDictionary *data_dictionary = [dictionary objectForKey:@"data"];
    
    NSArray*array_Regions = [data_dictionary objectForKey:@"Regions"];

    for (NSDictionary* dictionary in array_Regions) {

        newsObject = [[NewsModelClass alloc]init];
        NSString *title  = [dictionary valueForKey:knewsTitle];
        NSString *Description  = [dictionary valueForKey:knewsDescription];

        
        if ([dictionary valueForKey:knewsnewsType_id]) {
            newsObject.newsId = [dictionary valueForKey:knewsnewsType_id];
        }
        if ([dictionary valueForKey:knewsTitle]!= [NSNull null]) {
            newsObject.newsTitle = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        if ([dictionary valueForKey:knewsTitle]!= [NSNull null]) {
            newsObject.newsTagdesc = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        if (![[NSNull null] isEqual:Description]) {
            newsObject.newsDescription = [self parseHtmlResponse:Description];
        }
        
        newsObject.newsDate = [dictionary valueForKey:knewscreated_date];
        newsObject.newsImageUrl = [dictionary valueForKey:knewsimage];
        newsObject.newsDisplayName = [dictionary valueForKey:knewsdisplayName];

        
        newsObject.newsType_id = [dictionary valueForKey:knewsnewsType_id];
        newsObject.collection_id = [dictionary valueForKey:knewscollection_id];
       newsObject.newsDescription = [dictionary valueForKey:knewsDescription];
        newsObject.newsDescription = [self parseHtmlResponse:newsObject.newsDescription];

        newsObject.newsTitle = [dictionary valueForKey:knewsTitle];
        
        [arrayOfNewsObject addObject:newsObject];
        
    }
//    if (arrayOfBannerObject.count > 0) {
//        [arrayOfNewsAndBannerObject addObject:arrayOfBannerObject];
//    }
//    
//    if (arrayOfNewsObject.count > 0) {
//        [arrayOfNewsAndBannerObject addObject:arrayOfNewsObject];
//    }
//    
    completionHandler(arrayOfNewsObject);
}

-(void) parseResponseReturnedFromDataBase : (id) responseObject withCallBack : (void (^) ( NSMutableArray * arrayOfNews) )completionHandler {

NewsModelClass *newsObject;
    NSMutableArray *arrayOfNewsObject = [NSMutableArray array];
    for (BannerNews *object in responseObject) {
        
        newsObject = [[NewsModelClass alloc]init];

        newsObject.newsId = object.id;
        newsObject.newsTitle = object.title;
        newsObject.newsDate = object.date;
        newsObject.newsImageUrl = object.images;
        newsObject.newsDescription = object.newsDescription;
        newsObject.NewsPage_newsdetails = object.page_newsdetails;
        newsObject.newsTagdesc = object.tagdesc;
       
        [arrayOfNewsObject addObject:newsObject];
    }
    
 completionHandler(arrayOfNewsObject);
}

-(NSString*) parseHtmlResponse : (NSString*)newsDescription {
    
    NSData* data = [newsDescription dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];

    // 3
    NSString *tutorialsXpathQueryString = @"//p" ;
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    if (![tutorialsNodes count]) {
        tutorialsXpathQueryString = @"//div";
        tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    }    if (![tutorialsNodes count]) {
        tutorialsXpathQueryString = @"//span";
        tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    }
    //    // 4
    //    NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableString *string = [[NSMutableString alloc]init];
  
    for (TFHppleElement *element in tutorialsNodes) {
        // 5
        if ([[element children] count ]> 1) {
          [string appendString:@"\n"];
            for (int i =0 ; i < [[element children] count ] ; i++) {
                TFHppleElement * ele = [element nodeObjectAtIndex:i];
                [string appendString: [ele content]];
            }
        }
        
        else if ([[element firstChild]content]) {
           [string appendString:@"\n"];
            [string appendString:[[element firstChild] content]];
        }
    }
//    NSLog(@"value is %@", string);
    return string;
}

@end
