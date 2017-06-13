//
//  NavigationViewController.h
//  PCBNewsProject
//
//  Created by pawanag on 6/17/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "PageViewController.h"
#import "NewsModelClass.h"


@interface NavigationViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray *arrayOfTitles;
@property (nonatomic, strong) NSArray *arrayOfImages;
@property (nonatomic, strong) NewsModelClass *newsModelClass;
@property (strong, nonatomic) PageViewController *pageViewController;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSString* newsCategoryString;

- (IBAction)shareText:(UIBarButtonItem *)sender;

@end
