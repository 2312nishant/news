//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "DetailViewController.h"
#import "NavigationViewController.h"
#import "CategorizeUrl.h"

static NSString * const HomePage = @"Home Page";
static NSString * const HomePageCellIdentifier = @"HomePageCell";
static NSString * const LocationNameCellIdentifier = @"LocationNameCell";



@interface SidebarViewController ()


@end

@implementation SidebarViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    menuItems = @[@"Notifications",@"Banner", @"Pimpri", @"Chinchwad", @"Bhosari",@"Pune",@"Maharashtra", @"Desh", @"Videsh", @"Sampadakiya",@"Krida", @"Aarogya", @"Yuva Vishwa", @"Mahila Vishwa",@"Business", @"TantraGyan", @"Rashi Bhavishya", @"Career", @"Khadya Bhramanti",@"Life Style", @"Manoranjan", @"Rojgar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section ==0) {
        return 1;
    } else {
        return menuItems.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomePageCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = HomePage;
        
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationNameCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
        //        [cell.textLabel setAlpha:0.25];
        //        [cell.contentView setAlpha:0.25];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
}

#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath.section == 0) {
        if ([[CategorizeUrl getCurrentNewsCategory] isEqualToString:HomePage]) {
            [self.revealViewController performSelector:@selector(revealToggle:) withObject:Nil];
            return NO;
        }
    }
    else if (indexPath.section == 1) {
        if ([[CategorizeUrl getCurrentNewsCategory] isEqualToString:[menuItems objectAtIndex:indexPath.row]]) {
            [self.revealViewController performSelector:@selector(revealToggle:) withObject:Nil];
            return NO;
        }
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self.revealViewController performSelector:@selector(revealToggle:) withObject:self];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        [CategorizeUrl setCurrentNewsCategory:HomePage];
    } else if (indexPath.section == 1){
        [CategorizeUrl setCurrentNewsCategory:[menuItems objectAtIndex:indexPath.row]];
    }
    
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    if ([destViewController.viewControllers[0] isKindOfClass:[NavigationViewController class]]){
        NavigationViewController *destinationViewController = destViewController.viewControllers[0];
        destinationViewController.newsCategoryString = [menuItems objectAtIndex:indexPath.row];
        
    }
}

@end