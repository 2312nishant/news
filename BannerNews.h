//
//  BannerNews.h
//  PCBNewsProject
//
//  Created by pawanag on 4/27/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BannerNews : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * images;
@property (nonatomic, retain) NSString * tagdesc;
@property (nonatomic, retain) NSString * newsDescription;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * page_url;
@property (nonatomic, retain) NSString * page_newsdetails;
@property (nonatomic, retain) NSData  * image;


/*@property (nonatomic,strong) NSString * collection_id;
@property (nonatomic,strong) NSString * newsType_id;
@property (nonatomic,strong) NSString *  display_name;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * Banner_description;
@property (nonatomic,strong) NSString * created_date;

@property (nonatomic,strong)UIImage * image;
*/
@end
