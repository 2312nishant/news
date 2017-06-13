//
//  Constants.h
//  PCBNewsProject
//
//  Created by pawanag on 4/28/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#ifndef PCBNewsProject_Constants_h
#define PCBNewsProject_Constants_h


// keys for accessing the dictionary of response 
//            @property (nonatomic,strong) NSString * newsId;
//            @property (nonatomic,strong) NSString * newsTitle;
//            @property (nonatomic,strong) UIImage *  image;
//            @property (nonatomic,strong) NSString * newsImageUrl;
//            @property (nonatomic,strong) NSString * newsTagdesc;
//            @property (nonatomic,strong) NSString * newsDescription;
//
//            @property (nonatomic,strong) NSString * newsDate;
//            @property (nonatomic,strong) NSString * page_newsdetails;
//            @property (nonatomic,strong) NSString * newsPage_url;


#define knewsId @"id"
#define knewsTitle @"title"
#define knewscollection_id @"collection_id"
#define knewsnewsType_id @"newsType_id"
#define knewsdisplayName @"display_name"
#define knewsimage @"image"
#define knewscreated_date @"created_date"

#define knewsImageUrl @"images"
#define knewsTagdesc @"tagdesc"
#define knewsDescription @"description"
#define knewsDate @"date"
#define knewsPage_newsdetails @"page_newsdetails"
#define knewsPage_url @"page_url"

#define kBannerNewsEntity @"BannerNews"

//Banner
#define BannerCollectionId @"collection_id"
#define BannerNewsTypeId @"newsType_id"
#define BannerDisplayName @"display_name"
#define BannerTitle @"title"
#define BannerDescription @"description"
#define BannerCreatedDate @"created_date"
#define BannerImage @"image"

// notification

#define pcb_news_id @"pcb_news_id"


//
#endif
