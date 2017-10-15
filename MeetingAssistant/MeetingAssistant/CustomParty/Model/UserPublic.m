//
//  UserPublic.m
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "UserPublic.h"
#import "FMDB.h"

@interface UserPublic ()

@property (strong, nonatomic) FMDatabase *fmdb;

@end

@implementation UserPublic

__strong static UserPublic *_singleManger = nil;
+ (UserPublic *)getInstance {
    _singleManger = [[UserPublic alloc] init];
    return _singleManger;
}

- (instancetype)init {
    if (_singleManger) {
        return _singleManger;
    }
    self = [super init];
    if (self) {
        if (!self.fmdb) {
            NSLog(@"数据库出错");
        }
    }
    return self;
}

- (void)saveUserData:(AppUserInfo *)data {
    if (data) {
        _userData = data;
    }
    if (_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[_userData mj_keyValues] forKey:kUserData];
    }
}

- (void)clear {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserData];
    
    if (_fmdb) {
        [_fmdb close];
    }
    
    _singleManger = nil;
}

- (BOOL)creatMeetingRoom:(NSString *)name {
    if (!name.length) {
        return NO;
    }
    
    BOOL result = [self.fmdb executeUpdate:@"INSERT INTO meeting_room (user_id, room_name, room_image) VALUES (?, ?, ?)", self.userData.user_id, name, [NSString stringWithFormat:@"会议室图标%@", @(RandomInAggregate(1, 3))]];
    if (result) {
        _roomsArray = nil;
    }
    return result;
}

- (BOOL)removeMeetingRoom:(NSUInteger)index {
    if (index >= self.roomsArray.count) {
        return NO;
    }
    AppMeetingRoomInfo *room = self.roomsArray[index];
    BOOL result = [self.fmdb executeUpdate:@"DELETE FROM meeting_room WHERE room_id = ?", room.room_id];
    if (result) {
        [self.roomsArray removeObjectAtIndex:index];
    }
    return result;
}

- (void)addDeviceWithHost:(NSString *)host port:(int)port {
    if (self.selectedRoomInfo) {
        BOOL isExisted = NO;
        for (APPDeviceInfo *device in self.selectedRoomInfo.deviceArray) {
            if ([device.host isEqualToString:host]) {
                isExisted = YES;
                device.port = port;
                break;
            }
        }
        if (!isExisted) {
            APPDeviceInfo *device = [APPDeviceInfo new];
            device.host = [host copy];
            device.port = port;
            [self.selectedRoomInfo.deviceArray addObject:device];
        }
        
        [self postNotificationName:kNotification_DeviceRefresh object:nil];
    }
}

- (void)postNotificationName:(NSString *)name object:(id)anObject{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
    });
}

#pragma mark - getter
- (FMDatabase *)fmdb {
    if (!_fmdb) {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"user_meeting_rooms.sqlite"];
        _fmdb = [FMDatabase databaseWithPath:filePath];
        if ([_fmdb open]){
            BOOL result = [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS meeting_room (room_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, room_name TEXT, room_image TEXT)"];
            if (result) {
                
            }
        }
    }
    return _fmdb;
}

- (NSDictionary *)defaultUserGroup {
    if (!_defaultUserGroup) {
        NSString *key_id = @"user_id";
        NSString *key_pw = @"password";
        _defaultUserGroup = @{@"admin" : @{key_id : @"1000", key_pw : @"123456"},
                        @"test" : @{key_id : @"1001", key_pw : @"123456"}};
    }
    return _defaultUserGroup;
}

- (AppUserInfo *)userData {
    if (!_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [ud objectForKey:kUserData];
        if (data) {
            _userData = [AppUserInfo mj_objectWithKeyValues:data];
        }
    }
    return _userData;
}

- (NSMutableArray *)roomsArray {
    if (!_roomsArray) {
        _roomsArray = [NSMutableArray new];
        FMResultSet *resultSet = [self.fmdb executeQuery:@"SELECT * FROM meeting_room WHERE user_id = ?", self.userData.user_id];
        while ([resultSet next]) {
            NSDictionary *dic = resultSet.resultDictionary;
            [_roomsArray addObject:[AppMeetingRoomInfo mj_objectWithKeyValues:dic]];
        }
    }
    return _roomsArray;
}

- (NSMutableArray *)summaryArray {
    if (!_summaryArray) {
        _summaryArray = [NSMutableArray new];
    }
    return _summaryArray;
}

- (AppFontStyleInfo *)styleInfo {
    if (!_styleInfo) {
        _styleInfo = [AppFontStyleInfo new];
        _styleInfo.fontSize = 8;
    }
    return _styleInfo;
}

- (NSArray *)fontNameArray {
    if (!_fontNameArray) {
        _fontNameArray = @[@"宋体", @"微软雅黑", @"黑体"];
    }
    return _fontNameArray;
}

@end
