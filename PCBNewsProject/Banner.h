//
//  Banner.h
//  PCBNewsProject
//
//  Created by Amol Bhakare on 07/05/17.
//  Copyright © 2017 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Banner : NSObject

@property (nonatomic,strong) NSString * collection_id;
@property (nonatomic,strong) NSString * newsType_id;
@property (nonatomic,strong) NSString *  display_name;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * Banner_description;
@property (nonatomic,strong) NSString * created_date;

@property (nonatomic,strong)UIImage * image;

@end
