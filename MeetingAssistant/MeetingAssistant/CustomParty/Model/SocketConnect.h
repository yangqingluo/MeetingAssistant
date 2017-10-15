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

- (void)sendRegisterBroadcast;

- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (BOOL)connectToAddress:(NSData *)address error:(NSError **)errPtr;
- (void)disconnectToSocketServer;
- (void)sendFileData;

@end
