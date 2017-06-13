//
//  DetailViewController.m
//  PCBNewsProject
//
//  Created by pawanag on 5/16/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailListingViewViewController.h"
#import "CategorizeUrl.h"

@interface DetailViewController ()<UIActionSheetDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIActivityIndicatorView *detailActivityIndicator;

@property (nonatomic, strong) DetailListingViewViewController *detailListingViewController;
@property (nonatomic,assign) NSInteger indexForSharing;

@end

//static NSString * const urlString = @"http://pcbtoday.in";

//UAT
//static NSString * const urlString = @"http://pcbqa.pcbtoday.in/Api/index/getNewsDetails";


//PROD
//static NSString * const urlString = @"http://pcb.pcbtoday.in/Api/index/getNewsDetails";
static NSString * const urlString = @"http://pcbtoday.in/Api/index/getNewsDetails";


static NSString * const appUrlConstString = @"Download The PCB News App : ";


@implementation DetailViewController

-(NetworkManager*) networkManager {
    
    if (!_networkManager) {
        _networkManager = [[NetworkManager alloc]init];
    }
    return _networkManager;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.pageViewController.dataSource = self;
    
    [self loadActivityIndicator];
    [self disableScroll];
    if ([self.isNotification isEqualToString:@"Notification"])
    {
        [self loadActivityIndicatorOnDetailView];
        [self getArrayOfNewsObjectFromNotification:^(BOOL success)
        {
            [self createSlideVC];
            [self.detailActivityIndicator stopAnimating];
        } withFailure:^(BOOL failure)
        {
            [self.detailActivityIndicator stopAnimating];
        }];
    } else
    {
        [self loadActivityIndicator];
        [self getArrayOfNewsObject];
        [self createSlideVC];
    }
    
    self.navigationItem.title = self.newsModelClass.newsDisplayName;
}

-(void) disableScroll {
    
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = NO;
        }
    }
}

-(void) enableScroll {
    
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = YES;
        }
    }
}

#pragma mark networkCall

-(void) getArrayOfNewsObjectFromNotification : (void (^) (BOOL success))success1 withFailure :(void (^) (BOOL failure) )failure
{
    
    __weak DetailViewController *blockSelf = self;
    [self.networkManager getArrayOfLocationBasedNewsFromNotification:[CategorizeUrl getNewsUrlType:self.newsCategoryString ] withNewsId:self.newsModelClass.newsId withSuccess:^(BOOL success, NSMutableArray *arrayOfNews)
     {
         if (success)
         {
             if ([arrayOfNews count]) {
                 blockSelf.arrayOfTitles = arrayOfNews;
                 self.detailListingViewController.arrayOfTitles = arrayOfNews;
             }
             [blockSelf.activityIndicator stopAnimating];
             [blockSelf enableScroll];
             success1(true);
         }
     } withFailure:^(BOOL failure, NSError *error)
     {
         if (failure) {
             [blockSelf.activityIndicator stopAnimating];
             [blockSelf enableScroll];
         }
     }];
    
}


-(void) getArrayOfNewsObjectwithSuccess : (void (^) (BOOL success))success1 withFailure :(void (^) (BOOL failure) )failure
{
    
    __weak DetailViewController *blockSelf = self;
    [self.networkManager getArrayOfLocationBasedNewsWithLocationName:[CategorizeUrl getNewsUrlType:self.newsCategoryString ] withNewsId:self.newsModelClass.newsId withSuccess:^(BOOL success, NSMutableArray *arrayOfNews)
    {
        if (success)
        {
            if ([arrayOfNews count]) {
                blockSelf.arrayOfTitles = arrayOfNews;
                self.detailListingViewController.arrayOfTitles = arrayOfNews;
            }
            [blockSelf.activityIndicator stopAnimating];
            [blockSelf enableScroll];
            success1(true);
        }
    } withFailure:^(BOOL failure, NSError *error)
    {
        if (failure) {
            [blockSelf.activityIndicator stopAnimating];
            [blockSelf enableScroll];
        }
    }];
    
}

-(void) getArrayOfNewsObject
{
    __weak DetailViewController *blockSelf = self;
    [self.networkManager getArrayNewsList:self.newsModelClass.newsId limit:@"100" start:@"0" collection_id:self.newsModelClass.collection_id withSuccess:^(BOOL success, NSMutableArray *arrayOfNews)
    {
        if (success) {
            if ([arrayOfNews count])
            {
                blockSelf.arrayOfTitles = arrayOfNews;
                self.detailListingViewController.arrayOfTitles = arrayOfNews;
            }
            [blockSelf.activityIndicator stopAnimating];
            [blockSelf enableScroll];
        }
    } withFailure:^(BOOL failure, NSError *error) {
        if (failure) {
            [blockSelf.activityIndicator stopAnimating];
            [blockSelf enableScroll];
        }
    }];
    
}
-(void) loadActivityIndicator {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setCenter:self.pageViewController.view.center];
    [self.activityIndicator setColor:[UIColor blueColor]];
    [self.pageViewController.view addSubview:self.activityIndicator];
}

-(void) loadActivityIndicatorOnDetailView {
    
    self.detailActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setCenter:self.view.center];
    [self.activityIndicator setColor:[UIColor blueColor]];
    [self.view addSubview:self.activityIndicator];
}

-(void) createSlideVC {
    
    // Create page view controller
    self.pageControl = [UIPageControl appearance];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    DetailListingViewViewController * startingViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    //    [self.pageViewController shouldAutomaticallyForwardRotationMethods];
    // Change the size of page view controller
    //        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //    [self.pageViewController.view resignFirstResponder];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //    self.pageControl.alpha = 0.5;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.backgroundColor = [UIColor colorWithRed:0.0 green:0 blue:0.6 alpha:0.2];
    
}

- (void) viewWillLayoutSubviews {
    
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    
    for (UIView *view in [self.view subviews]){
        view.frame = CGRectMake(viewBounds.origin.x, viewBounds.origin.y+topBarOffset, viewBounds.size.width, viewBounds.size.height-topBarOffset);
    }
}

- (DetailListingViewViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    self.detailListingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
      if (index == 0 && [self.isNotification isEqualToString:@"Notification"]) {
          
        NewsModelClass * news = self.arrayOfTitles[0];
          
        self.detailListingViewController.newsModelClass = news;
          
          
        self.arrayOfTitles = nil;
          
          
          
     }
      else if (index == 0)
      {
         self.detailListingViewController.newsModelClass = self.newsModelClass;
     }
      else{
        if (self.arrayOfTitles[index])
        {
            self.detailListingViewController.newsModelClass = self.arrayOfTitles[index];
      }
         
    }
    self.detailListingViewController.newsCategoryString = self.newsCategoryString;
    self.detailListingViewController.arrayOfTitles = self.arrayOfTitles;
    self.detailListingViewController.pageIndex = index;
    
    return self.detailListingViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DetailListingViewViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    self.indexForSharing = index;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DetailListingViewViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    self.indexForSharing = index;
    if (index == [self.arrayOfTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    if ([self.arrayOfTitles count]==0) {
        return 7;
    }
    else {
        return [self.arrayOfTitles count];
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButton:(id)sender {
    
    //    [self shareText];
    NSString *title = [NSString stringWithFormat:@"Share %@ News", self.newsCategoryString];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Share"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Share Text", @"Share News Link", title, nil];
    
    [actionSheet showInView:self.view];
}
#pragma Mark UIActionSheetdelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self shareText];
    } else if (buttonIndex ==1) {
        [self shareLink];
    } else if (buttonIndex ==2) {
        [self shareNews];
    }
}
- (void)shareText {
    
    NewsModelClass *model;
    if (self.indexForSharing == 0)
    {
        model = self.newsModelClass;
    } else if (self.indexForSharing < [self.arrayOfTitles count] && self.indexForSharing > 0)
    {
        model = [self.arrayOfTitles objectAtIndex:self.indexForSharing-1];
    }
    
    NSString *downloadURLString = [NSString stringWithFormat:@"https://itunes.apple.com/in/app/pcb-news/id1012547755?mt=8"];
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    
    NSString *string = model.newsDescription;
    if (string) {
        NSArray *objectsToShare = @[string, appUrlConstString, downloadURL];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        NSArray *excludedActivities = @[UIActivityTypePrint];
        controller.excludedActivityTypes = excludedActivities;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)shareLink {
    
    NewsModelClass *model;
    if (self.indexForSharing == 0)
    {
        model = self.newsModelClass;
    } else if (self.indexForSharing < [self.arrayOfTitles count] && self.indexForSharing > 0)
    {
        model = [self.arrayOfTitles objectAtIndex:self.indexForSharing-1];
        
    }
       NSString *urlStringToBeShared = [NSString stringWithFormat:@"PCB News - %@", self.newsCategoryString];
    
    NSString *name = [NSString stringWithFormat:@"%@",model.NewsPage_newsdetails];
    NSString *string = [NSString stringWithFormat:@"%@/%@%@", urlString, name, self.newsModelClass.newsId];
    NSString *downloadURLString = [NSString stringWithFormat:@"https://itunes.apple.com/in/app/pcb-news/id1012547755?mt=8"];
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    
    if (string) {
    NSURL *url = [NSURL URLWithString:string];
    
    NSArray *objectsToShare = @[urlStringToBeShared,url,appUrlConstString,downloadURL];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePrint];
    controller.excludedActivityTypes = excludedActivities;
    [self presentViewController:controller animated:YES completion:nil];
     }
}

- (void)shareNews {
    
    NewsModelClass *model;
    if (self.indexForSharing == 0)
    {
        model = self.newsModelClass;
    } else if (self.indexForSharing < [self.arrayOfTitles count] && self.indexForSharing > 0)
    {
        model = [self.arrayOfTitles objectAtIndex:self.indexForSharing-1];
        
    }
    NSString *urlStringToBeShared = [NSString stringWithFormat:@"PCB News - %@", self.newsCategoryString];
    
    NSString *name = [NSString stringWithFormat:@"%@",model.newsPage_url];
    NSString *string = [NSString stringWithFormat:@"%@/%@", urlString, name];
    
    NSString *downloadURLString = [NSString stringWithFormat:@"https://itunes.apple.com/in/app/pcb-news/id1012547755?mt=8"];
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    
     if (string) {
    NSURL *url = [NSURL URLWithString:string];
    
    NSArray *objectsToShare = @[urlStringToBeShared,url,appUrlConstString,downloadURL];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[ UIActivityTypePrint];
    
    controller.excludedActivityTypes = excludedActivities;
    [self presentViewController:controller animated:YES completion:nil];
    }
}


@end
