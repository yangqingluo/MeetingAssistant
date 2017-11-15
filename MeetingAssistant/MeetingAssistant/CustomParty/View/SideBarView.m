//
//  SideBarView.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SideBarView.h"

@interface SideBarView (){
    float _nSpaceNavY;
}

@property (nonatomic, strong) UIView *navView;

@end

@implementation SideBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(self.width, 0, 350, self.height)];
        self.baseView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"侧滑栏内容区域背景"].CGImage);
        [self addSubview:self.baseView];
    }
    return self;
}

- (void)setupNavigationViews{
    _nSpaceNavY = 20;
    double StatusbarSize = 0.0;
    if (iosVersion >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1){
        _nSpaceNavY = 0;
        StatusbarSize = 20.0;
    }
    
    _navigationBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.baseView.width, 64 - _nSpaceNavY)];
    [self.baseView addSubview:_navigationBarView];
    [_navigationBarView setBackgroundColor:MainColor];
    
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.baseView.width, 44.f)];
    ((UIImageView *)_navView).backgroundColor = [UIColor clearColor];
    [self.baseView addSubview:_navView];
    _navView.userInteractionEnabled = YES;
    
    self.titleLabel.frame = CGRectMake(60, (_navView.height - 40) * 0.5, _navView.width - 120, 40);
    [_navView addSubview:self.titleLabel];
}

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem{
    [self setupNavigationViews];
    self.titleLabel.text = szTitle;
    NSUInteger itemCount = 4;
    for (int i = 0; i < itemCount; i++) {
        UIView *item = menuItem(i);
        if (item){
            [_navView addSubview:item];
        }
    }
}

- (void)showInView:(UIView *)view {
    self.frame = self.bounds;
    [view addSubview:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.baseView.right = self.width;
    [UIView commitAnimations];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.baseView.left = self.width;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch view] == self) {
        [self dismiss];
    }
}

#pragma getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return _titleLabel;
}

@end
