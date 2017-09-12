//
//  UserPublic.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicNavViewController.h"

@interface UserPublic : NSObject

+ (UserPublic *)getInstance;

@property (strong, nonatomic) PublicNavViewController *mainNavVC;

//用户登陆数据
@property (strong, nonatomic) AppUserInfo *userData;

//保存用户数据
- (void)saveUserData:(AppUserInfo *)data;
//清除
- (void)clear;

@end
