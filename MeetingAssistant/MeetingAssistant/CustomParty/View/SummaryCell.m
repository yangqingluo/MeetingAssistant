//
//  SummaryCell.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SummaryCell.h"

@implementation SummaryCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView.frame = self.bounds;
        [self.contentView addSubview:self.imgView];
        [AppPublic roundCornerRadius:self.imgView cornerRadius:8];
        
        CGFloat radius = 22;
        self.removeButton.frame = CGRectMake(self.width - radius - kEdgeSmall, kEdgeSmall, radius, radius);
        [self.contentView addSubview:self.removeButton];
    }
    return self;
}

@end
