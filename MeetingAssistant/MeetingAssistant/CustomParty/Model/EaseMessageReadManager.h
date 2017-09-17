/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <Foundation/Foundation.h>

#import "MWPhotoBrowser.h"

typedef void (^FinishBlock)(BOOL success);

@class EMChatFireBubbleView;
@interface EaseMessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray;

- (void)showBrowserWithImages:(NSArray *)imageArray currentPhotoIndex:(NSUInteger)index;

@end
