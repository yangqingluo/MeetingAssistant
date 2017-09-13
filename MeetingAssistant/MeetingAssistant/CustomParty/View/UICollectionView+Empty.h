//
//  UICollectionView+Empty.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/13.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UICollectionView (Empty)

- (NSUInteger)showContentWithMessage:(NSString *)message image:(UIImage *)image forNumberOfItemsInSection:(NSUInteger)count;

@end
