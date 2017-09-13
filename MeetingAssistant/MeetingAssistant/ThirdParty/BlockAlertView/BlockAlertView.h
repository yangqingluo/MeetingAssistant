//
//  BlockAlertView.h
//  digitalhome
//
//  Created by fullreader on 13-9-23.
//  Copyright (c) 2013年 defshare. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger);
typedef void(^AlertSelfBlock)(UIAlertView *alert, NSInteger index);

@interface BlockAlertView : UIAlertView

@property(nonatomic, copy) AlertBlock block;
@property(nonatomic, copy) AlertSelfBlock callBlock;

- (instancetype)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
                  callBlock:(AlertSelfBlock)_block
            otherButtonTitles:(NSString *)otherButtonTitles, ...;


@end
