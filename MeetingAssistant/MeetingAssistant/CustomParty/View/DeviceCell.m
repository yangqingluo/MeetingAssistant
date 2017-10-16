//
//  DeviceCell.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/14.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DeviceCell.h"

#import "UIResponder+Router.h"

@implementation DeviceCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.baseView];
        [AppPublic roundCornerRadius:self.baseView cornerRadius:4.0];
        
        self.imgView.frame = CGRectMake(18, 20, 60, 60);
        self.imgView.backgroundColor = [UIColor whiteColor];
        self.imgView.image = [UIImage imageNamed:@"已关闭头像"];
//        self.imgView.highlightedImage = [UIImage imageNamed:@"点亮状态头像"];
        [self.baseView addSubview:self.imgView];
        
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(58, 71, 18, 18)];
        _tagImageView.image = [UIImage imageNamed:@"已关闭状态"];
//        _tagImageView.highlightedImage = [UIImage imageNamed:@"已点亮状态"];
        [self.baseView addSubview:_tagImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 23, 200, 25)];
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.baseView addSubview:self.nameLabel];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLabelAction)];
        self.nameLabel.userInteractionEnabled = YES;
        [self.nameLabel addGestureRecognizer:gesture];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 52, 200, 20)];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = RGBA(0x66, 0x66, 0x66, 1.0);
        [self.baseView addSubview:_addressLabel];
        
        _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 74, 200, 20)];
        _summaryLabel.font = [UIFont systemFontOfSize:14];
        _summaryLabel.textColor = RGBA(0x66, 0x66, 0x66, 1.0);
        [self.baseView addSubview:_summaryLabel];
        
        _summaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _summaryButton.frame = CGRectMake(0, 106, 78, 30);
        _summaryButton.right = self.baseView.width - 18;
        _summaryButton.layer.borderWidth = 1.0;
        _summaryButton.layer.borderColor = baseBlueColor.CGColor;
        [AppPublic roundCornerRadius:_summaryButton cornerRadius:3.0];
        _summaryButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_summaryButton setTitle:@"会议纪要" forState:UIControlStateNormal];
        [_summaryButton setTitleColor:baseBlueColor forState:UIControlStateNormal];
        [self.baseView addSubview:_summaryButton];
        
        _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lightButton.frame = CGRectMake(0, _summaryButton.top, 60, _summaryButton.height);
        _lightButton.right = self.summaryButton.left - 18;
        _lightButton.layer.borderWidth = 1.0;
        _lightButton.layer.borderColor = baseBlueColor.CGColor;
        [AppPublic roundCornerRadius:_lightButton cornerRadius:3.0];
        _lightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _lightButton.backgroundColor = baseBlueColor;
        [_lightButton setTitle:@"点亮" forState:UIControlStateNormal];
        [_lightButton setTitle:@"关闭" forState:UIControlStateSelected];
        [_lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lightButton addTarget:self action:@selector(lightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:_lightButton];
        
        _loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadButton.frame = CGRectMake(0, 20, 27, 27);
        _loadButton.right = self.summaryButton.right;
        [_loadButton setImage:[UIImage imageNamed:@"下载按钮"] forState:UIControlStateNormal];
        [_loadButton addTarget:self action:@selector(loadBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:_loadButton];
        
        _loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _loadLabel.centerY = _loadButton.centerY;
        _loadLabel.right = _loadButton.right;
        _loadLabel.textAlignment = NSTextAlignmentRight;
        _loadLabel.textColor = RGBA(0x99, 0x99, 0x99, 1.0);
        _loadLabel.font = [UIFont systemFontOfSize:14];
        _loadLabel.text = @"已下载";
        _loadLabel.hidden = YES;
        [self.baseView addSubview:_loadLabel];
        
        self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOpacity = 0.12;
    }
    
    return self;
}

- (void)lightBtnAction {
    if (self.indexPath) {
        [self routerEventWithName:Event_DeviceCellLightButton userInfo:self.indexPath];
    }
}

- (void)loadBtnAction {
    if (self.indexPath) {
        [self routerEventWithName:Event_DeviceCellLoadButton userInfo:self.indexPath];
    }
}

- (void)nameLabelAction {
    if (self.indexPath) {
        [self routerEventWithName:Event_DeviceCellNameLabel userInfo:self.indexPath];
    }
}

#pragma mark - setter
- (void)setData:(APPDeviceInfo *)data {
    _data = data;
    
//    self.imgView.highlighted = data.lighted;
//    self.tagImageView.highlighted = data.lighted;
    self.imgView.image = [UIImage imageNamed:data.lighted ? @"点亮状态头像" :@"已关闭头像"];
    self.tagImageView.image = [UIImage imageNamed:data.lighted ? @"已点亮状态" : @"已关闭状态"];
    
    self.nameLabel.text = data.device_name.length ? data.device_name : @"待编辑";
    self.addressLabel.text = [NSString stringWithFormat:@"IP：%@", data.host];
    self.summaryLabel.text = [NSString stringWithFormat:@"会议纪要：%@", data.summary.count ? @"[图片]" : @"无"];
    self.lightButton.selected = data.lighted;
    self.loadButton.hidden = (data.summary.count > 0);
    self.loadLabel.hidden = !data.summary.count;
}

@end
