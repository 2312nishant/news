//
//  DetailListingViewViewController.m
//  PCBNewsProject
//
//  Created by pawanag on 4/21/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "DetailListingViewViewController.h"
#import "MainNewsCell.h"
#import "ListingNewsCell.h"
#import "DetailTextCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "CategorizeUrl.h"
#import "NoDataView.h"

//UAT
//static NSString * const imageUrl = @"http://pcbqa.pcbtoday.in/uploads";

//PROD
//static NSString * const imageUrl = @"http://pcb.pcbtoday.in/uploads";
static NSString * const imageUrl = @"http://pcbtoday.in/uploads";


//static NSString * const urlString = @"http://www.pcbtoday.in/";

@interface DetailListingViewViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end

@implementation DetailListingViewViewController

-(NetworkManager*) networkManager {
    if (!_networkManager) {
        _networkManager = [[NetworkManager alloc]init];
    }
    return _networkManager;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self.arrayOfTitles count] &&  nil != self.newsModelClass)
    {
        [self getArrayOfNewsObject];
    }
    else if(self.newsModelClass == nil)
    {
        self.tableView.hidden = YES;
//        NoDataView *view = [NoDataView overlayView];
//        [self.view addSubview:view];
    }
//    self.arrayOfTitles=[self.arrayOfTitles removeObjectsInRange:NSMakeRange(1, self.arrayOfTitles.count-1)];

//    self.arrayOfTitles = [self.arrayOfTitles removeObjectsAtIndexes:<#(nonnull NSIndexSet *)#>:0];
}

-(NSMutableArray*) arrayOfTitles {
    
    if (!_arrayOfTitles) {
        _arrayOfTitles = [[NSMutableArray alloc]init];
    }
    return _arrayOfTitles;
}

-(void) loadActivityIndicator {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setCenter:self.view.center];
    [self.activityIndicator setColor:[UIColor blueColor]];
    [self.view addSubview:self.activityIndicator];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark methods for getting array of news

-(void) getArrayOfNewsObject {
    
    __weak DetailListingViewViewController *blockSelf = self;
    [self.networkManager getArrayNewsList:self.newsModelClass.newsId limit:@"100" start:@"0" collection_id:self.newsModelClass.collection_id withSuccess:^(BOOL success, NSMutableArray *arrayOfNews) {
        if (success) {
            if ([arrayOfNews count]) {
                blockSelf.arrayOfTitles = arrayOfNews;
                [blockSelf.tableView reloadData];
            }
            [blockSelf.activityIndicator stopAnimating];
        }
    } withFailure:^(BOOL failure, NSError *error) {
        if (failure) {
            [blockSelf.activityIndicator stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving News"
                                                                message:[error localizedDescription]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Retry", nil];
            [alertView show];
        }
    }];
    
}



//-(void) getArrayOfNewsObject {
//    
//    __weak DetailListingViewViewController *blockSelf = self;
//    [self.networkManager getArrayOfLocationBasedNewsWithLocationName:[CategorizeUrl getNewsUrlType:self.newsCategoryString ] withNewsId:self.newsModelClass.newsId withSuccess:^(BOOL success, NSMutableArray *arrayOfNews) {
//        if (success) {
//            if ([arrayOfNews count]) {
//                blockSelf.arrayOfTitles = arrayOfNews;
//                [blockSelf.tableView reloadData];
//            }
//            [blockSelf.activityIndicator stopAnimating];
//        }
//    } withFailure:^(BOOL failure, NSError *error) {
//        if (failure) {
//            [blockSelf.activityIndicator stopAnimating];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving News"
//                                                                message:[error localizedDescription]
//                                                               delegate:self
//                                                      cancelButtonTitle:@"Cancel"
//                                                      otherButtonTitles:@"Retry", nil];
//            [alertView show];
//        }
//    }];
//    
//}

-(void) getArrayOfNewsObjectAtIndexPath:(NSInteger)lastRowIndex {
    
    __weak DetailListingViewViewController *blockSelf = self;
    [self loadActivityIndicator];
    NewsModelClass *newsModelClass = [self.arrayOfTitles objectAtIndex:lastRowIndex];
    NSString* newsId = newsModelClass.newsId;
    
    [self.networkManager getArrayOfLocationBasedNewsWithLocationName:[CategorizeUrl getNewsUrlType:self.newsCategoryString ] withNewsId:newsId withSuccess:^(BOOL success, NSMutableArray *arrayOfNews) {
        if (success) {
            if ([arrayOfNews count]) {
                [blockSelf.arrayOfTitles addObjectsFromArray:arrayOfNews];
                [blockSelf.tableView reloadData];
            }
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

# pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    
    else {
        
        if ([self.arrayOfTitles count])
        {
            

            return [self.arrayOfTitles count];
        } else {
            return 0;
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        return [self mainNewsCellAtIndexPath:indexPath];
        
    }  else if(indexPath.section ==1)
    {
        return [self detailTextOfMainNews:indexPath];
    }
    else
    {
        return [self listingNewsCellAtIndexPath:indexPath];
    }
}

# pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
    NSLog(@"indexpath row %ld", (long)indexPath.row);
   NSLog(@"indexpath section %ld", (long)indexPath.section);
    
//NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];

    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    NSLog(@"%ld %ld",(long)index.row,(long)index.section);

    [indexPaths addObject:index];
    
    if (indexPath.section == 2)
    {
        
//        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];

        
        [UIView animateWithDuration:3.0 animations:^{
            [tableView setContentOffset:CGPointZero animated:YES];
        } completion:^(BOOL finished)
        {
            if (finished) {
                self.newsModelClass = [self.arrayOfTitles objectAtIndex:indexPath.row];
//                self.newsModelClass = [self.arrayOfTitles objectAtIndex:newIndexPath.row];

//               [self.tableView reloadData];
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

            }
   
        }];
        
    }
    [self.activityIndicator stopAnimating];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 220.0f;
    } else if (indexPath.section == 1) {
        return [self heightForBasicCellAtIndexPath:indexPath];
    } else {
        return 80.0f;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex]-1;
    
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        [self getArrayOfNewsObjectAtIndexPath:lastRowIndex ];
    }
}

# pragma mark tableview cell height

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static DetailTextCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"detailTextCell"];
    });
    
    [self configureDetailTextCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(DetailTextCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

# pragma mark configure tableview cell

- (DetailTextCell *)detailTextOfMainNews:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"detailTextCell";
    DetailTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    [self configureDetailTextCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureDetailTextCell:(DetailTextCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NewsModelClass *newsObject = self.newsModelClass;
    cell.detailText.text = newsObject.newsDescription;
    cell.titleLabel.text = newsObject.newsTitle;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    [cell.detailText updateConstraintsIfNeeded];
    
    cell.detailText.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    //    [self addBorderForCell : cell];
}

-(void) addBorderForCell :(DetailTextCell *)cell {
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 1.0;
    bottomBorder.frame = CGRectMake(-1, cell.titleLabel.layer.frame.size.height+4, cell.titleLabel.layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor blueColor].CGColor];
    [cell.titleLabel.layer addSublayer:bottomBorder];
    
}

- (MainNewsCell *)mainNewsCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MainNewsCell";
    MainNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    [self configureMainNewsCell:cell atIndexPath:indexPath];
    
    
    return cell;
}
- (void)configureMainNewsCell:(MainNewsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NewsModelClass *newsObject = self.newsModelClass;
    NSString *str1 = newsObject.newsDate;
    NSRange range = [str1 rangeOfString:@" "];
    
    NSString *dateString = [str1 substringToIndex:range.location];
    
    cell.dateLabel.text = dateString;
    if (newsObject.image) {
        
        cell.mainNewsImage.image = newsObject.image;
    }
    else
    {
        [self configureImageForMainNewsCell:cell ForNewsObject:newsObject];
    }
}

-(void) configureImageForMainNewsCell:(MainNewsCell *)cell ForNewsObject :(NewsModelClass*) newsObject {
    
    NSString *stringByAppendingImageUrl;
    
    if (newsObject.newsImageUrl && ![[NSNull null] isEqual:newsObject.newsImageUrl]) {
        
        
        stringByAppendingImageUrl = [imageUrl stringByAppendingString: [NSString stringWithFormat:@"/%@",newsObject.newsId]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",newsObject.newsImageUrl]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    NSURL *url = [NSURL URLWithString:stringByAppendingImageUrl];
    NSLog(@"Url is %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [cell.mainNewsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pcb180x180"]];
    
}

- (ListingNewsCell *)listingNewsCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ListingNewsCell";
    ListingNewsCell *cell;
    if (cell == Nil)
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.listingNewsImage.image = Nil;

//        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];

        [self configureListingNewsCell:cell atIndexPath:indexPath];
    }
    

    return cell;
}

- (void)configureListingNewsCell:(ListingNewsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
//    NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];

    NewsModelClass *newsObject = [self.arrayOfTitles objectAtIndex:indexPath.row] ;
    if (newsObject.image)
    {
        cell.listingNewsImage.image = newsObject.image;
    }
    else
    {
        [self configureImageForListingNewsCell:cell ForNewsObject:newsObject];
    }
    cell.listingNewsLabel.text = newsObject.newsTitle;

}

-(void) configureImageForListingNewsCell:(ListingNewsCell *)cell ForNewsObject :(NewsModelClass*) newsObject {
    
    NSString *stringByAppendingImageUrl;
    if (newsObject.newsImageUrl && ![[NSNull null] isEqual:newsObject.newsImageUrl]) {
        
        stringByAppendingImageUrl = [imageUrl stringByAppendingString: [NSString stringWithFormat:@"/%@",newsObject.newsId]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",newsObject.newsImageUrl]];
        
        stringByAppendingImageUrl = [stringByAppendingImageUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    NSURL *url = [NSURL URLWithString:stringByAppendingImageUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [cell.listingNewsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pcb180x180"]];
    
}

@end
