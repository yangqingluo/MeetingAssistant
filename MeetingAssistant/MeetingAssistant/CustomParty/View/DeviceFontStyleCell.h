//
//  DeviceFontStyleCell.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceFontStyleCell : UITableViewCell

@property (nonatomic, strong) UILabel *styleLabel;
@property (nonatomic, strong) UIImageView *tagImageView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL like;

@end
