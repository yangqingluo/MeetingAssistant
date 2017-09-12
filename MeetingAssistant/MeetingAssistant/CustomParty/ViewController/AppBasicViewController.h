//
//  AppBasicViewController.h
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KGViewExtend.h"

#define iosVersion      ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface AppBasicViewController : UIViewController

@property (nonatomic, strong) UIImageView *navigationBarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *navBottomLine;
@property (copy,   nonatomic) DoneBlock doneBlock;

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;
- (void)dismissKeyboard;

@end
