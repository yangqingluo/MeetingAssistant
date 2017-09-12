//
//  AppBasicViewController.m
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"

@interface AppBasicViewController (){
    float _nSpaceNavY;
}

@property (nonatomic, strong) UIView *navView;

@end

@implementation AppBasicViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
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
    
    _navigationBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.width, 64 - _nSpaceNavY)];
    [self.view addSubview:_navigationBarView];
    [_navigationBarView setBackgroundColor:MainColor];
    
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.view.width, 44.f)];
    ((UIImageView *)_navView).backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navView];
    _navView.userInteractionEnabled = YES;
    
    self.navBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _navView.bounds.size.height - 0.5, _navView.bounds.size.width, 0.5)];
    self.navBottomLine.backgroundColor = baseSeparatorColor;
    self.navBottomLine.hidden = YES;
    [_navView addSubview:self.navBottomLine];
    
    self.titleLabel.frame = CGRectMake(60, (_navView.height - 40) * 0.5, _navView.width - 120, 40);
    [_navView addSubview:self.titleLabel];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = lightWhiteColor;
}

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem{
    [self setupNavigationViews];
    
    self.title = szTitle;
    
    NSUInteger itemCount = 4;
    for (int i = 0; i < itemCount; i++) {
        UIView *item = menuItem(i);
        if (item){
            [_navView addSubview:item];
        }
    }
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma setter
- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.titleLabel.text = title;
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
