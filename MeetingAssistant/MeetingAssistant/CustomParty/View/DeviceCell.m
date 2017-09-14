//
//  DeviceCell.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/14.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.baseView];
        [AppPublic roundCornerRadius:self.baseView cornerRadius:4.0];
        
        self.imgView.frame = CGRectMake(kEdgeBig, 0, 42, 34);
        self.imgView.centerY = 0.5 * self.baseView.height;
        self.imgView.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:self.imgView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.right + kEdgeBig, 0, self.baseView.width - kEdge - (self.imgView.right + kEdgeBig), self.baseView.height)];
        self.nameLabel.font = [UIFont systemFontOfSize:17];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.numberOfLines = 0;
        [self.baseView addSubview:self.nameLabel];
        
        self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOpacity = 0.12;
    }
    
    return self;
}

@end
