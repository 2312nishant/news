//
//  NoDataView.m
//  PCBNewsProject
//
//  Created by pawanag on 7/24/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView()

@property (nonatomic, weak) IBOutlet UIView *overlayView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation NoDataView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)overlayView {
    NoDataView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(NoDataView.class) owner:self options:nil] firstObject];
    return view;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.alpha = 0.5;
    self.userInteractionEnabled = NO;
    
    self.gradientLayer = ({
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.overlayView.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        //        gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#000000" alpha:0.75].CGColor, (id)[UIColor colorWithHexString:@"#000000" alpha:0.95].CGColor];
        
        //        gradientLayer.colors = [UIColor blueColor];
        self.overlayView.backgroundColor = [UIColor clearColor];
        [self.overlayView.layer addSublayer:gradientLayer];
        
        gradientLayer;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.overlayView.bounds;
}


@end
