//
//  SlideImageViewController.h
//  PCBNewsProject
//
//  Created by pawanag on 7/14/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideImageViewController : UIViewController

@property NSUInteger pageIndex;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(UIView *) getImageView ;
@end
