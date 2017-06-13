//
//  Header.h
//  PCBNewsProject
//
//  Created by pawanag on 4/30/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#ifndef PCBNewsProject_Header_h
#define PCBNewsProject_Header_h


#endif



//- (void)configureListingNewsCell:(HomeListingNewsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//
//    NewsModelClass *newsObject = [self.arrayOfTitles objectAtIndex:indexPath.row] ;
//    NSString *stringByAppendingImageUrl = [urlString stringByAppendingString: newsObject.newsImageUrl];
//    NSURL *url = [NSURL URLWithString:stringByAppendingImageUrl];
//    [cell.homeListingNewsImage setImageWithURL:url];
//    cell.homeListingNewslabel.text = newsObject.newsTitle;
//
//
//    //    if (newsObject.image) {
//    //        cell.homeListingNewsImage.image = newsObject.image;
//    //    } else {
//    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
//    //            NSString *string = @"http://www.pcbtoday.in/admin/";
//    //            NSString *str2 = [string stringByAppendingString: newsObject.newsImageUrl];
//    //
//    //            NSURL *url = [NSURL URLWithString:str2];
//    //
//    //            NSData *data = [NSData dataWithContentsOfURL:url];
//    //            cell.homeListingNewsImage.image = [[UIImage alloc] initWithData:data];
//    //
//    //        dispatch_async(dispatch_get_main_queue(), ^{ // 2
//    //            cell.homeListingNewsImage.image = [[UIImage alloc] initWithData:data];
//    //            newsObject.image = [[UIImage alloc] initWithData:data];
//    //        });
//    //    });
//    //}
//
//
//
//}
//

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self heightForHomeNewsCellAtIndexPath:indexPath];
//}

//- (CGFloat)heightForHomeNewsCellAtIndexPath:(NSIndexPath *)indexPath {
//   static NSString *simpleTableIdentifier = @"MainNewsCell";
//    static HomeMainNewsCell *sizingCell = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sizingCell = [self.tableVIiew dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    });
//
//    [self configureMainNewsCell:sizingCell atIndexPath:indexPath];
//    return [self calculateHeightForConfiguredMainNewsSizingCell:sizingCell];
//}
//
//- (CGFloat)calculateHeightForConfiguredMainNewsSizingCell:(UITableViewCell *)sizingCell {
//    [sizingCell setNeedsLayout];
//    [sizingCell layoutIfNeeded];
//
//    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1.0f; // Add 1.0f for the cell separator height
//}
//
//- (CGFloat)heightForListingCellAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *simpleTableIdentifier = @"ListingNewsCell";
//    static HomeListingNewsCell *sizingCell = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sizingCell = [self.tableVIiew dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    });
//
//    [self configureListingNewsCell:sizingCell atIndexPath:indexPath];
//    return [self calculateHeightForListingNewsSizingCell:sizingCell];
//}
//
//- (CGFloat)calculateHeightForListingNewsSizingCell:(UITableViewCell *)sizingCell {
//    [sizingCell setNeedsLayout];
//    [sizingCell layoutIfNeeded];
//
//    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1.0f; // Add 1.0f for the cell separator height
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0.0;
//    }
//    else {
//    return self.heightOfHeader;
//    }
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    NSString *string =@"hello";
//    /* Section header is in 0th index... */
//    [label setText:string];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:100/255.0 green:0/255.0 blue:120/255.0 alpha:1.0]]; //your background color...
//    return view;
//}