//
//  DeviceStyleView.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DeviceStyleView.h"

@implementation DeviceStyleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createNavWithTitle:@"名牌风格" createMenuItem:^UIView *(int nIndex){
            if (nIndex == 0){
                UIButton *btn = NewBackButton(nil);
                [btn setTitle:@"关闭" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
                self.backButton = btn;
                return btn;
            }
            else if (nIndex == 1){
                UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
                
                [btn setFrame:CGRectMake(self.baseView.width - 64, 0, 54, 44)];
                self.saveButton = btn;
                return btn;
            }
            
            return nil;
        }];
    }
    return self;
}

@end
