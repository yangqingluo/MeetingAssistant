//
//  MeetingRoomCell.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "MeetingRoomCell.h"

@implementation MeetingRoomCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.baseView.backgroundColor = lightWhiteColor;
        [self.contentView addSubview:self.baseView];
        [self.contentView bringSubviewToFront:self.removeButton];
        
        self.imgView.frame = CGRectMake(0, 0, self.baseView.width, self.baseView.width);
//        self.imgView.contentMode = UIViewContentModeScaleToFill;
        self.removeButton.frame = CGRectMake(self.baseView.right - 2 * kEdge, self.baseView.top, 2 * kEdge, 2 * kEdge);
        [self.baseView addSubview:self.imgView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeSmall, self.imgView.bottom, 20, self.baseView.height - self.imgView.bottom)];
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.numberOfLines = 0;
        [self.baseView addSubview:self.nameLabel];
    }
    
    return self;
}

@end
