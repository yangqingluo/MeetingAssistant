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

- (BOOL)creatMeetingRoomAction:(NSString *)nameString {
    if (!nameString.length) {
        return NO;
    }
    
    BOOL result = [self.fmdb executeUpdate:@"INSERT INTO meeting_room (user_id, room_name, room_image) VALUES (?, ?, ?);", self.userData.user_id, nameString, [NSString stringWithFormat:@"会议室图标%@", @(RandomInAggregate(1, 3))]];
    if (result) {
        _roomsArray = nil;
    }
    return result;
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
        FMResultSet *resultSet = [self.fmdb executeQuery:@"SELECT * FROM meeting_room"];
        
        //遍历结果
        while ([resultSet next]) {
            NSDictionary *dic = resultSet.resultDictionary;
            [_roomsArray addObject:[AppMeetingRoomInfo mj_objectWithKeyValues:dic]];
        }
    }
    return _roomsArray;
}

@end
