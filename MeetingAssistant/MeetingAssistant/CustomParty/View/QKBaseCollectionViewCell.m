//
//  QKBaseCollectionViewCell.m
//
//  Created by yangqingluo on 15/11/9.
//  Copyright © 2015年 yangqingluo. All rights reserved.
//

#import "QKBaseCollectionViewCell.h"

@implementation QKBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        double radius = 14;
        double aveWH = CGRectGetWidth( self.frame );
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, radius, aveWH - radius, aveWH - radius)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        [self.contentView addSubview:self.imgView];
        
        self.removeButton = [[UIButton alloc]initWithFrame:CGRectMake(aveWH - 2 * radius, 0, 2 * radius, 2 * radius)];
        [self.removeButton setImage:[UIImage imageNamed:@"删除图片按钮"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.removeButton];
    }
    return self;
}

- (void)startAnimation {
    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    momAnimation.fromValue = @(-0.005);
    momAnimation.toValue = @0.005;
    momAnimation.duration = 0.1;
    momAnimation.repeatCount = CGFLOAT_MAX;
    momAnimation.autoreverses = YES;;
    [self.contentView.layer addAnimation:momAnimation forKey:@"animateLayer"];
}

- (void)stopAnimation {
    [self.contentView.layer removeAllAnimations];
}

@end
