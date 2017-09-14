//
//  QKBaseCollectionViewCell.h
//
//  Created by yangqingluo on 15/11/9.
//  Copyright © 2015年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QKBaseCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *removeButton;

- (void)startAnimation;
- (void)stopAnimation;

@end
