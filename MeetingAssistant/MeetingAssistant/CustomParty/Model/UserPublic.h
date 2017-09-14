//
//  UserPublic.h
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicNavViewController.h"

@interface UserPublic : NSObject

+ (UserPublic *)getInstance;

@property (strong, nonatomic) PublicNavViewController *mainNavVC;

//默认用户组
@property (strong, nonatomic) NSDictionary *defaultUserGroup;

//用户登陆数据
@property (strong, nonatomic) AppUserInfo *userData;
//用户会议室数据
@property (strong, nonatomic) NSMutableArray *roomsArray;

//保存用户数据
- (void)saveUserData:(AppUserInfo *)data;
//清除用户数据
- (void)clear;
//创建会议室
- (BOOL)creatMeetingRoom:(NSString *)name;
//删除会议室
- (BOOL)removeMeetingRoom:(NSUInteger)index;

@end
