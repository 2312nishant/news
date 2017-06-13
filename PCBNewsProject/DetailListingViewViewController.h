//
//  DetailListingViewViewController.h
//  PCBNewsProject
//
//  Created by pawanag on 4/21/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModelClass.h"
#import "NetworkManager.h"

@interface DetailListingViewViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *arrayOfTitles;
@property (nonatomic, strong) NewsModelClass *newsModelClass;
@property (nonatomic, strong) NSString* newsCategoryString;
@property NSUInteger pageIndex;

@end
