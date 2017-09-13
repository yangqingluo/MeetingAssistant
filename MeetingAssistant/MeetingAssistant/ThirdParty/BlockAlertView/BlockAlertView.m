//
//  BlockAlertView.m
//  digitalhome
//
//  Created by fullreader on 13-9-23.
//  Copyright (c) 2013年 defshare. All rights reserved.
//

#import "BlockAlertView.h"

@implementation BlockAlertView

@synthesize block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        self.block = _block;
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

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
                    callBlock:(AlertSelfBlock)_block
            otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        self.callBlock = _block;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block) {
        self.block(buttonIndex);
    }
    
    if (self.callBlock) {
        self.callBlock(self, buttonIndex);
    }
}

@end
