//
//  ViewController.m
//  PCBNews
//
//  Created by pawanag on 4/13/15.
//  Copyright (c) 2015 cybage. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking/AFHTTPRequestOperation.h"
#import "NetworkManager.h"
#import "NewsModelClass.h"
#import "DetailListingViewViewController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "DataBasemanager.h"
#import "BannerNews.h"
#import "Banner.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "ListingNewsCell.h"
#import "MainNewsCell.h"
#import "NewsParserClass.h"
#import "SlideImageViewController.h"
#import "AppDelegate.h"

//static NSString * const urlString = @"http://www.pcbtoday.in/";
//UAT
//static NSString * const imageUrl = @"http://pcbqa.pcbtoday.in/uploads";
//static NSString * const urlString = @"http://pcbqa.pcbtoday.in/Api/index/dashboard";

//PROD
//static NSString * const imageUrl = @"http://pcb.pcbtoday.in/uploads";
static NSString * const imageUrl = @"http://pcbtoday.in/uploads";
static NSString * const urlString = @"http://pcb.pcbtoday.in/Api/index/dashboard";


static NSString * const appUrlConstString = @"Download The PCB News App : ";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
- (IBAction)ShareAppLink:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableVIiew;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *arrayOfTitles;
@property (nonatomic, strong) NSMutableArray *arrayOfBanners;
@property (nonatomic, strong) NSArray *arrayOfImages;
@property (nonatomic, strong) NewsModelClass *newsModelClass;
@property (nonatomic, strong) Banner * bannerModelClass;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) PageViewController *pageViewController;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ViewController

-(NSManagedObjectContext*)managedObjectContext {
    
    if(!_managedObjectContext) {
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
    }
    return _managedObjectContext;
}

-(NewsModelClass*) newsModelClass {
    
    if (!_newsModelClass) {
        _newsModelClass = [[NewsModelClass alloc]init];
    }
    return _newsModelClass;
}

-(NetworkManager*) networkManager {
    if (!_networkManager) {
        _networkManager = [[NetworkManager alloc]init];
    }
    return _networkManager;
    
}
#pragma ViewControllerLifeCycleMethods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableVIiew.hidden = YES;
    [self loadActivityIndicator];
    [self createRefreshController];
    [self getArrayOfNewsObject];
    [self createSideBarMenu];
    
    self.menuItems = @[@"Notifications", @"Pimpri", @"Chinchwad", @"Bhosari",@"Pune",@"Maharashtra", @"Desh", @"Videsh", @"Sampadakiya",@"Krida", @"Aarogya", @"Yuva Vishwa",@"Business", @"TantraGyan", @"Rashi Bhavishya", @"Career", @"Khadya Bhramanti",@"Life Style", @"Manoranjan", @"Rojgar"];
    
    [self.tableVIiew setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    //Hides Drawer button
    self.navigationItem.leftBarButtonItem = nil;
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadActivityIndicator {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setCenter:self.view.center];
    [self.activityIndicator setColor:[UIColor blueColor]];
    [self.view addSubview:self.activityIndicator];
}

-(void) getArrayOfNewsObject
{
    
    __weak ViewController *blockSelf = self;
    [self.networkManager getArrayOfBannerNews:@"str" withSuccess:^(BOOL success, NSMutableArray *arrayOfNews)
    {
        if (success)
        {
 //           blockSelf.newsModelClass = [arrayOfNews objectAtIndex:0];
            
//            blockSelf.arrayOfBanners = [arrayOfNews objectAtIndex:0];
//            blockSelf.arrayOfTitles = [arrayOfNews objectAtIndex:1];
            
            blockSelf.arrayOfTitles = arrayOfNews;

           //[blockSelf.arrayOfTitles removeObjectAtIndex:1];
            blockSelf.tableVIiew.hidden = NO;
            [blockSelf.activityIndicator stopAnimating];
            [blockSelf.tableVIiew reloadData];
            [self saveDataToDatabase];
        }
        
    } withFailure:^(BOOL failure, NSError *error) {
        if (failure) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving News"
                                                                message:[error localizedDescription]
                                                               delegate:self
                                                      cancelButtonTitle:@"Load Saved News"
                                                      otherButtonTitles:@"Retry", nil];
            [blockSelf.activityIndicator stopAnimating];
            [alertView show];
        }
    }];
    
}

-(void) saveDataToDatabase {
    
    // will be using core data in the subsequent releases
    
    DataBasemanager *dataBasemanager = [[DataBasemanager alloc]init];
    [dataBasemanager insertBanernewsDataIntoCoreData:self.arrayOfTitles withSuccess:^(BOOL success) {
        if (success) {
        }
    } withFailure:^(BOOL failure) {
        if (failure) {
        }
    }];
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

-(void) createRefreshController {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor blueColor]];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableVIiew addSubview:self.refreshControl];
}

-(void) handleRefresh : (UIRefreshControl*) control {
    
    [self.refreshControl endRefreshing];
}

-(void) getDataFromDatabase
{
    
    __weak ViewController *blockSelf = self;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kBannerNewsEntity];
    NSMutableArray *array;
    array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NewsParserClass *npc = [[NewsParserClass alloc]init];
    self.arrayOfTitles = [[NSMutableArray alloc]init];
    [npc parseResponseReturnedFromDataBase:array withCallBack:^(NSMutableArray *arrayOfNews) {
        blockSelf.arrayOfTitles = arrayOfNews;
    }];
    
    if ([self.arrayOfTitles count]) {
        self.tableVIiew.hidden = NO;
        //    [self.activityIndicator stopAnimating];
        [self.tableVIiew reloadData];
    }
}

#pragma alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [self.activityIndicator stopAnimating];
        [self getDataFromDatabase];
    } else {
        [self.activityIndicator startAnimating];
        [self getArrayOfNewsObject];
    }
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==0) {
//        if ([self.arrayOfBanners count]) {
//            return 1;
//        } else {return 0; }
        return 1;
    } else {
        return [self.arrayOfTitles count];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 220.0f;
    }else {
        return 80.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row ==0 && indexPath.section == 0)
    {
        return [self mainNewsCellAtIndexPath:indexPath];
    }
    else
    {
        return [self listingNewsCellAtIndexPath:indexPath];
    }
    
}

- (MainNewsCell *)mainNewsCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MainNewsCell";
    MainNewsCell *cell = [self.tableVIiew dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    [self configureMainNewsCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureMainNewsCell:(MainNewsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    
     SelectedBannerId=0;
    
    for (int i=0; i<self.arrayOfTitles.count; i++) {
        
        if ([((NewsModelClass *)[self.arrayOfTitles objectAtIndex:i]).newsId isEqualToString:@"1"]) {
            
            SelectedBannerId = i;
            
        }
        
    }
    
    NewsModelClass *newsObject = [self.arrayOfTitles objectAtIndex:SelectedBannerId];
    
    NSString *stringByAppendingImageUrl;
//    if (![[NSNull null] isEqual:newsObject.image] && newsObject.image)
//    {
//        stringByAppendingImageUrl = [imageUrl stringByAppendingString: [NSString stringWithFormat:@"/%@",newsObject.newsType_id]];
//
//        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",newsObject.image]];
//        
//        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//
//    }
//    
//    NSURL *url = [NSURL URLWithString:stringByAppendingImageUrl];
//    [cell.mainNewsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pcb180x180"]];
//    cell.mainNewsLabel.text = newsObject.newsTitle;
//
    if (![[NSNull null] isEqual:newsObject.newsImageUrl] && newsObject.newsImageUrl)
    {
        stringByAppendingImageUrl = [imageUrl stringByAppendingString: [NSString stringWithFormat:@"/%@",newsObject.newsId]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",newsObject.newsImageUrl]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSLog(@"stringByAppendingImageUrl->%@",stringByAppendingImageUrl);
    }
    
    NSURL *url = [NSURL URLWithString:stringByAppendingImageUrl];
    
    [cell.mainNewsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pcb180x180"]];
    
    cell.mainNewsLabel.text = newsObject.newsTitle;
    //cell.listingNewsCateg0ryLabel.text = newsObject.newsDescription;

}

- (ListingNewsCell *)listingNewsCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ListingNewsCell";
    ListingNewsCell *cell;
    if (!cell)
    {
        cell = [self.tableVIiew dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        [self configureListingNewsCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (void)configureListingNewsCell:(ListingNewsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NewsModelClass *newsObject = [self.arrayOfTitles objectAtIndex:indexPath.row] ;
    NSString *stringByAppendingImageUrl;
    if (![[NSNull null] isEqual:newsObject.newsImageUrl] && newsObject.newsImageUrl)
    {
        stringByAppendingImageUrl = [imageUrl stringByAppendingString: [NSString stringWithFormat:@"/%@",newsObject.newsId]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",newsObject.newsImageUrl]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

        NSLog(@"stringByAppendingImageUrl->%@",stringByAppendingImageUrl);
    }

    NSURL *url = [NSURL URLWithString:stringByAppendingImageUrl];
    
    [cell.listingNewsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pcb180x180"]];
    
    cell.listingNewsLabel.text = newsObject.newsTitle;
    cell.listingNewsCateg0ryLabel.text = newsObject.newsDisplayName;

}

#pragma mark Navigation

-(void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]] && [segue.identifier isEqualToString:@"ListingNewsIdentifier"])
    {
        [segue.destinationViewController setNewsCategoryString:[self.menuItems objectAtIndex:[self.tableVIiew indexPathForSelectedRow ].row]];
        [segue.destinationViewController setNewsModelClass:[self.arrayOfTitles objectAtIndex:[self.tableVIiew indexPathForSelectedRow ].row]];
        
    } else if ([segue.destinationViewController isKindOfClass:[DetailViewController class]] && [segue.identifier isEqualToString:@"BannerNewsIdentifier"])
    {
        
        [segue.destinationViewController setNewsCategoryString:@"Banner"];
//        [segue.destinationViewController setNewsModelClass:[self.arrayOfBanners objectAtIndex:[self.tableVIiew indexPathForSelectedRow ].row]];
        
        [segue.destinationViewController setNewsModelClass:[self.arrayOfTitles objectAtIndex:SelectedBannerId]];
        
//
    }
}
- (IBAction)sideBarButton:(id)sender {
}

- (IBAction)ShareAppLink:(id)sender {
    
  
    NSString *string = [NSString stringWithFormat:@"https://itunes.apple.com/in/app/pcb-news/id1012547755?mt=8"];
    NSURL *url = [NSURL URLWithString:string];
    NSArray *objectsToShare = @[appUrlConstString,url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[ UIActivityTypePrint,
                                    UIActivityTypeAirDrop,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList,
                                    UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo];
    
    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
