//
//  AppType.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppType : NSObject

@end

@interface AppUserInfo : AppType

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;

@end
