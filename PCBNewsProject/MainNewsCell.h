//
//  MainNewsCell.h
//  PCBNewsProject
//
//  Created by pawanag on 5/21/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainNewsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainNewsImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
