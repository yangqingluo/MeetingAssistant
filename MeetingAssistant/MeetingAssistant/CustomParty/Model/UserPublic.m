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
    
    _singleManger = nil;
}

#pragma mark - getter
- (NSDictionary *)adminUsers {
    if (!_adminUsers) {
        NSString *key_id = @"user_id";
        NSString *key_pw = @"password";
        _adminUsers = @{@"admin" : @{key_id : @"ma1000", key_pw : @"123456"},
                        @"test" : @{key_id : @"ma1001", key_pw : @"123456"}};
    }
    return _adminUsers;
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

- (FMDatabase *)fmdb {
    if (!_fmdb) {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"user_meeting_rooms.sqlite"];
        _fmdb = [FMDatabase databaseWithPath:filePath];
        if ([_fmdb open]){
            BOOL result = [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (room_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, room_name TEXT, room_image TEXT);"];
            if (result) {
                
            }
        }
    }
    return _fmdb;
}

@end
