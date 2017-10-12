//
//  SocketConnect.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/10/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SocketConnect.h"
#import "MAStruct.h"
#import "GCDAsyncUdpSocket.h"

@interface SocketConnect ()<GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;

@end

@implementation SocketConnect

__strong static SocketConnect  *_singleManger = nil;
+ (SocketConnect *)getInstance {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _singleManger = [[SocketConnect alloc] init];
    });
    return _singleManger;
}

- (instancetype)init {
    if (_singleManger) {
        return _singleManger;
    }
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)senfRegisterBroadcast {
    REGISTER_BROADCAST package = {0};
    package.port = 10001;
    [self.udpSocket sendData:[self buildWithType:CMD_REGISTER_BROADCAST Pbuf:(char *)&package Len:sizeof(REGISTER_BROADCAST)] toHost:@"255.255.255.255" port:9527 withTimeout:-1 tag:0];
}

- (NSData *)buildWithType:(int)type Pbuf:(char *)pbuf Len:(int)len{
    NET_UDP_PACKAGE package = {0};
    package.header = NET_PACK_HEADER;
    package.type = type;
    if (pbuf && len > 0){
        memcpy((void *)(package.data), (void *)pbuf, len);
    }
    NSMutableData *theData = [NSMutableData data];
    [theData appendBytes:&package length:12 + len];
    return theData;
}

#pragma getter
- (GCDAsyncUdpSocket *)udpSocket {
    if (!_udpSocket) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_udpSocket bindToPort:10001 error:nil];
        [_udpSocket enableBroadcast:YES error:nil];
        [_udpSocket beginReceiving:nil];
    }
    return _udpSocket;
}

#pragma GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    NSLog(@"receiveData：%@",data);
    NSString *receive = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"udpSocket didReceiveDataFrom: %@\n%@", [GCDAsyncUdpSocket hostFromAddress:address], receive);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"udpSocket didSendData.");
}

@end
