//
//  DetailTextCell.h
//  PCBNewsProject
//
//  Created by pawanag on 4/21/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCBAppLabel.h"

@interface DetailTextCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PCBAppLabel *detailText;
@property (weak, nonatomic) IBOutlet PCBAppLabel *titleLabel;


@end
