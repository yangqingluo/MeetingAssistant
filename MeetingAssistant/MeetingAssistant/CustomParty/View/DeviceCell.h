//
//  DeviceCell.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/14.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "QKBaseCollectionViewCell.h"

#define Event_DeviceCellLightButton    @"Event_DeviceCellLightButton"
#define Event_DeviceCellLoadButton     @"Event_DeviceCellLoadButton"
#define Event_DeviceCellSummaryButton  @"Event_DeviceCellSummaryButton"
#define Event_DeviceCellNameLabel      @"Event_DeviceCellNameLabel"

@interface DeviceCell : QKBaseCollectionViewCell

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIImageView *tagImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *summaryLabel;
@property (strong, nonatomic) UIButton *lightButton;
@property (strong, nonatomic) UIButton *summaryButton;
@property (strong, nonatomic) UIButton *loadButton;
@property (strong, nonatomic) UILabel *loadLabel;

@property (copy, nonatomic) APPDeviceInfo *data;

@end
