//
//  SideBarView.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarView : UIView

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIImageView *navigationBarView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *saveButton;


- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;
- (void)showInView:(UIView *)view;
- (void)dismiss;


@end
