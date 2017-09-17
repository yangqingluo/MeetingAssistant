//
//  BlockActionSheet.h
//  CRM2017
//
//  Created by yangqingluo on 2017/5/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetBlock)(NSInteger);

@interface BlockActionSheet : UIActionSheet

@property (nonatomic, copy) ActionSheetBlock block;

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<UIActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                  clickButton:(ActionSheetBlock)block
            otherButtonTitles:(NSString *)otherButtonTitles, ...;


@end
