//
//  AddFriendView.m
//  MallTemplate
//
//  Created by hu on 15/4/25.
//  Copyright (c) 2015年 udows. All rights reserved.
//

#import "AddFriendView.h"

@implementation AddFriendView

- (IBAction)a:(id)sender {
    
}

-(void)show
{
    self.hidden=NO;
    _isShow=YES;
//    CGRect rect = self.frame;
//    rect.size.height=0;
//    self.frame=rect;
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        CGRect rect = self.frame;
//        rect.size.height=110;
//        self.frame=rect;
//       // self.hidden=NO;
//        _isShow=YES;
//    } completion:nil];
}
-(void)dismiss
{
    self.hidden=YES;
    _isShow=NO;
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CGRect rect = self.frame;
//        rect.size.height=0;
//        self.frame=rect;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        _isShow=NO;
//    }];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([super pointInside:point withEvent:event]) {
        return YES;
    }
    else
    {
        
        [self dismiss];
        return YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
