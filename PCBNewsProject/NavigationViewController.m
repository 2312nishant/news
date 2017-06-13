//
//  NavigationViewController.m
//  PCBNewsProject
//
//  Created by pawanag on 6/17/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "NavigationViewController.h"
#import "NetworkManager.h"
#import "CategorizeUrl.h"
#import "DetailListingViewViewController.h"
#import "PollViewController.h"
#import "TVCViewController.h"

static NSString * const urlString = @"http://pcbtoday.in";
static NSString * const appUrlConstString = @"Download The PCB News App : ";
@interface NavigationViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,assign) NSInteger indexForSharing;
@end

@implementation NavigationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createSideBarMenu];
    if ([self.newsCategoryString isEqualToString:@"Poll"]) {
        [self addPollViewController];
    }
    else {
    
    [self getArrayOfNewsObject];
        [self loadActivityIndicator];
    }
}

-(void) addPollViewController {
//    PollViewController *pvc = [[PollViewController alloc]init];
//    pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PollViewController"];
////    PollViewController *pvc = [[PollViewController alloc]init];
////    [self.view addSubview:pvc.view];
//    [ self addChildViewController:pvc];

}
- (void)viewWillAppear:(BOOL)animated {
    
//    [super viewWillAppear:YES];
    
//    [UIView animateWithDuration:1.5f
//                     animations:^{
//                         [self.view setAlpha:1.0f];
//                     }
//     ];
    self.navigationItem.title = self.newsCategoryString;
}
-(void) createSideBarMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    SidebarViewController *sidebarviewcontroller = [[SidebarViewController alloc]init];
    sidebarviewcontroller.presentView = self.title;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}
-(NetworkManager*) networkManager {
    
    if (!_networkManager) {
        _networkManager = [[NetworkManager alloc]init];
    }
    return _networkManager;
    
}

#pragma mark networkCall

-(void) getArrayOfNewsObject {
    
    __weak NavigationViewController* blockSelf = self;
    [self.networkManager getArrayOfLocationBasedNewsWithLocationName:[CategorizeUrl getNewsUrlType:self.newsCategoryString ] withNewsId:self.newsModelClass.newsId withSuccess:^(BOOL success, NSMutableArray *arrayOfNews) {
        
        if (success) {
            if ([arrayOfNews count]) {
                blockSelf.arrayOfTitles = arrayOfNews;
                [blockSelf createSlideVC];
            }
            //            self.newsModelClass = [self.arrayOfTitles objectAtIndex:1];
            [blockSelf.activityIndicator stopAnimating];
        }
        
    } withFailure:^(BOOL failure, NSError *error) {
        if (failure) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving News"
                                                                message:[error localizedDescription]
                                                               delegate:self
                                                      cancelButtonTitle:@"Load Saved News"
                                                      otherButtonTitles:@"Retry", nil];
            [alertView show];
        }
        [blockSelf.activityIndicator stopAnimating];
    }];
    
}

-(void) loadActivityIndicator {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
    
    DetailListingViewViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
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
    if ((index >= [self.arrayOfTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    
    DetailListingViewViewController *detailListingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    if (index == 0) {
        detailListingViewController.newsModelClass = self.arrayOfTitles[0];
    } else {
        detailListingViewController.newsModelClass = self.arrayOfTitles[index];
    }
    detailListingViewController.arrayOfTitles = self.arrayOfTitles;
    detailListingViewController.pageIndex = index;
    
    return detailListingViewController;
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
    
    if (index == NSNotFound || index == [self.arrayOfTitles count]) {
        return nil;
    }
    
    index++;
    self.indexForSharing = index;
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

- (IBAction)shareText:(UIBarButtonItem *)sender {
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
    if (self.indexForSharing == 0) {
        if (self.newsModelClass) {
             model = self.newsModelClass;
        }else {
            model = [self.arrayOfTitles firstObject];
        }
    } else if (self.indexForSharing < [self.arrayOfTitles count] && self.indexForSharing > 0){
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
    if (self.indexForSharing == 0) {
        if (self.newsModelClass) {
            model = self.newsModelClass;
        }else {
            model = [self.arrayOfTitles firstObject];
        }
    } else if (self.indexForSharing < [self.arrayOfTitles count] && self.indexForSharing > 0){
        model = [self.arrayOfTitles objectAtIndex:self.indexForSharing-1];
    }
    NSString *urlStringToBeShared = [NSString stringWithFormat:@"PCB News - %@", self.newsCategoryString];
    
    NSString *name = [NSString stringWithFormat:@"%@",model.NewsPage_newsdetails];
    NSString *string = [NSString stringWithFormat:@"%@/%@%@", urlString, name, model.newsId];
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
    if (self.indexForSharing == 0) {
        if (self.newsModelClass) {
            model = self.newsModelClass;
        }else {
            model = [self.arrayOfTitles firstObject];
        }
    } else if (self.indexForSharing < [self.arrayOfTitles count] && self.indexForSharing > 0){
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