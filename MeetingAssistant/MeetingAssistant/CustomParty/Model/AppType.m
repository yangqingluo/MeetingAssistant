//
//  AppType.m
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppType.h"

@implementation AppType

- (instancetype)copyWithZone:(NSZone *)zone{
    return [[self class] mj_objectWithKeyValues:[self mj_keyValues]];
}

@end

@implementation AppUserInfo



@end


@implementation APPDeviceInfo



@end

@implementation AppFontStyleInfo



@end


@implementation AppMeetingRoomInfo

#pragma mark - getter
- (NSMutableArray *)deviceArray {
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray new];
    }
    return _deviceArray;
}

- (AppFontStyleInfo *)styleInfo {
    if (!_styleInfo) {
        _styleInfo = [AppFontStyleInfo new];
        _styleInfo.fontSize = 40;
    }
    return _styleInfo;
}

@end


