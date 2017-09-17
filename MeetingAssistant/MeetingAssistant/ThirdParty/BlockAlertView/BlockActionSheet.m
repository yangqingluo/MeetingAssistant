//
//  BlockActionSheet.m
//  CRM2017
//
//  Created by yangqingluo on 2017/5/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "BlockActionSheet.h"

@interface BlockActionSheet()<UIActionSheetDelegate>

@end

@implementation BlockActionSheet

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<UIActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                  clickButton:(ActionSheetBlock)block
            otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    
    if (self) {
        self.block = block;
        self.delegate = self;
        
        va_list args;
        va_start(args, otherButtonTitles);
        NSString *  btnTitle = otherButtonTitles;
        while (btnTitle) {
            [self addButtonWithTitle:btnTitle];
            btnTitle = va_arg(args, NSString *);
        }
        va_end(args);
    }
    
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.block(buttonIndex);
}

@end
