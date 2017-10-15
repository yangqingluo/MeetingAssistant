//
//  SocketConnect.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/10/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MACommand.h"

#define socket_searchDone  0x1000
#define socket_cmdTimeout  0x1001
//#define socket_cmdResp     0x1002

#define kNotification_Socket    @"kNotification_Socket"


@interface SocketConnect : NSObject

+ (SocketConnect *)getInstance;

- (void)startSearchingDevices;
- (void)stopSearchingDevices;
- (void)operationLightOpen:(BOOL)open host:(NSString *)host port:(int)port;

- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (BOOL)connectToAddress:(NSData *)address error:(NSError **)errPtr;
- (void)disconnectToSocketServer;
- (void)sendFileData;

@end
