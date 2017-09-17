//
//  DeviceFontStyleCell.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DeviceFontStyleCell.h"

@implementation DeviceFontStyleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        _styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 7, 350 - 2 * kEdge, 50)];
        _styleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _styleLabel.layer.borderWidth = 1.0;
        _styleLabel.textColor = [UIColor whiteColor];
        _styleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_styleLabel];
        
        [AppPublic roundCornerRadius:_styleLabel cornerRadius:4.0];
//        [AppPublic autoresizeMaskFlexibleLeftAndRightMargin:_styleLabel];
        
        _tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选择字体右上角角标"]];
        _tagImageView.top = _styleLabel.top;
        _tagImageView.right = _styleLabel.right;
        _tagImageView.hidden = YES;
        [self.contentView addSubview:_tagImageView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.styleLabel.text = [NSString stringWithFormat:@"  %@", title];
}

- (void)setLike:(BOOL)like{
    _like = like;
    UIColor *color = [UIColor whiteColor];
    if (like) {
        color = baseBlueColor;
    }
    
    self.styleLabel.layer.borderColor = color.CGColor;
    self.styleLabel.textColor = color;
    self.tagImageView.hidden = !like;
}

@end
