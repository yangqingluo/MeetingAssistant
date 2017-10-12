//
//  SocketConnect.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/10/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketConnect : NSObject

+ (SocketConnect *)getInstance;

- (void)senfRegisterBroadcast;

@end
