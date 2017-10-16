//
//  DeviceFontSizeCell.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DeviceFontSizeCell.h"

@implementation DeviceFontSizeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _minusButton.frame = CGRectMake(kEdge, 0, 110, 36);
        _minusButton.centerY = 0.5 * kCellHeight;
        [_minusButton setImage:[UIImage imageNamed:@"字号-按钮"] forState:UIControlStateNormal];
        [self.contentView addSubview:_minusButton];
        
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusButton.frame = CGRectMake(350 - kEdge - 110, 0, 110, _minusButton.height);
        _plusButton.centerY = _minusButton.centerY;
        [_plusButton setImage:[UIImage imageNamed:@"字号+按钮"] forState:UIControlStateNormal];
        [self.contentView addSubview:_plusButton];
        
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_minusButton.right, _minusButton.top, _plusButton.left - _minusButton.right, _minusButton.height)];
        _sizeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _sizeLabel.layer.borderWidth = 1.0;
        _sizeLabel.textColor = [UIColor whiteColor];
        _sizeLabel.font = [UIFont systemFontOfSize:16];
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_sizeLabel];
        
        _minusButton.tag = 0;
        [_minusButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _plusButton.tag = 1;
        [_plusButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self updateSizeLabel:[UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateSizeLabel:(NSUInteger)size {
    self.sizeLabel.text = [NSString stringWithFormat:@"%lu号", (unsigned long)size];
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 0) {
        [UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize--;
        if ([UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize < 1) {
            [UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize = 1;
        }
    }
    else {
        [UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize++;
        if ([UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize > 50) {
            [UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize = 50;
        }
    }
    [self updateSizeLabel:[UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize];
}

@end
