//
//  UIButton+Image&Text.m
//  SmartTeaching
//
//  Created by yangqingluo on 16/4/25.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "UIButton+ImageAndText.h"

@implementation UIButton(ImageAndText)

- (void)verticalImageAndTitle:(CGFloat)spacing{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:self.titleLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize textSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:drawOptions attributes:attibutes context:nil].size;
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
