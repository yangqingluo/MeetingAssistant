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
//选中的会议室
@property (strong, nonatomic) AppMeetingRoomInfo *selectedRoomInfo;
//会议纪要图片数据
@property (strong, nonatomic) NSMutableArray *summaryArray;
//名牌风格数据
@property (strong, nonatomic) AppFontStyleInfo *styleInfo;
//字体名称
@property (strong, nonatomic) NSArray *fontNameArray;

//保存用户数据
- (void)saveUserData:(AppUserInfo *)data;
//清除用户数据
- (void)clear;
//创建会议室
- (BOOL)creatMeetingRoom:(NSString *)name;
//删除会议室
- (BOOL)removeMeetingRoom:(NSUInteger)index;
//添加名牌设备
- (void)addDeviceWithHost:(NSString *)host port:(int)port;

@end
