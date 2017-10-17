//
//  SocketConnect.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/10/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MACommand.h"

#define socket_searchDone        0x1000
#define socket_cmdTimeout        0x1010
//#define socket_cmdResp          0x1011

#define socket_tcpSendDone       0x2000
#define socket_connectTimeout    0x2001
#define socket_connectFailed     0x2002
#define socket_connectDone       0x2003

#define kNotification_Socket    @"kNotification_Socket"


@interface SocketConnect : NSObject

+ (SocketConnect *)getInstance;

- (void)startSearchingDevices;
- (void)stopSearchingDevices;
- (void)operationLightOpen:(BOOL)open host:(NSString *)host port:(int)port;

- (void)updateDeviceName:(NSString *)name imageData:(NSData *)data host:(NSString *)host;

@end
