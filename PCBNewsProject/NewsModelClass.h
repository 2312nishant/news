//
//  NewsModelClass.h
//  PCBNewsProject
//
//  Created by pawanag on 4/20/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsModelClass : NSObject

@property (nonatomic,strong) NSString * newsId;
@property (nonatomic,strong) NSString * newsTitle;
@property (nonatomic,strong) UIImage *  image;
@property (nonatomic,strong) NSString * newsImageUrl;
@property (nonatomic,strong) NSString * newsTagdesc;
@property (nonatomic,strong) NSString * newsDescription;

@property (nonatomic,strong) NSString * newsDisplayName;

@property (nonatomic,strong) NSString * newsDate;
@property (nonatomic,strong) NSString * NewsPage_newsdetails;
@property (nonatomic,strong) NSString * newsPage_url;

@property (nonatomic,strong) NSString * newsType_id;
@property (nonatomic,strong) NSString * collection_id;








@end
