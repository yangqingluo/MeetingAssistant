//
//  UICollectionView+Empty.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/13.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "UICollectionView+Empty.h"

@implementation UICollectionView (Empty)

- (NSUInteger)showContentWithMessage:(NSString *)message image:(UIImage *)image forNumberOfItemsInSection:(NSUInteger)count {
    if (count) {
        self.backgroundView = nil;
    }
    else {
        UIView *tipView = [UIView new];
        UIImageView *noDataImage  = [[UIImageView alloc] initWithImage:image];
        noDataImage.center = CGPointMake(0.5 * screen_width, (350.0 / 768.0) * screen_height);
        [tipView addSubview:noDataImage];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, noDataImage.bottom + kEdgeBig, screen_width, 40)];
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [AppPublic adjustLabelHeight:messageLabel];
        [tipView addSubview:messageLabel];
        
        self.backgroundView = tipView;
    }
    return count;
}

@end
