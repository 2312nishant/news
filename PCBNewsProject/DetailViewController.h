//
//  DetailViewController.h
//  PCBNewsProject
//
//  Created by pawanag on 5/16/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModelClass.h"
#import "PageViewController.h"

@interface DetailViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *arrayOfTitles;
@property (nonatomic, strong) NSArray *arrayOfImages;
@property (nonatomic, strong) NewsModelClass *newsModelClass;
@property (strong, nonatomic) PageViewController *pageViewController;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSString* newsCategoryString;
@property (nonatomic, strong) NSString* isNotification;
- (IBAction)shareButton:(id)sender;

@end
