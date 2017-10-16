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
        
        [self.baseView addSubview:self.removeButton];
        self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOpacity = 0.12;
        
//        UILabel *label1 = [[UILabel alloc] initWithFrame:self.nameLabel.frame];
//        label1.font = [UIFont fontWithName:@"AppSongti" size:17];
//        NSLog(@"%@", label1.font.fontName);
//        label1.numberOfLines = 0;
//        label1.text = @"\n\n测试";
//        [self.baseView addSubview:label1];
    }
    
    return self;
}

#pragma mark - setter
- (void)setRoomInfo:(AppMeetingRoomInfo *)roomInfo {
    _roomInfo = roomInfo;
    
    self.imgView.image = [UIImage imageNamed:roomInfo.room_image];
    self.nameLabel.text = roomInfo.room_name;
}

@end
