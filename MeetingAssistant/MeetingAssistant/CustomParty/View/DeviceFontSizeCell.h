//
//  DeviceFontSizeCell.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFontSizeMax             120
#define kFontSizeMin             40

@interface DeviceFontSizeCell : UITableViewCell

@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UIButton *plusButton;

@end
