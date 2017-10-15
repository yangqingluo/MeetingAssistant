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
#import "GCDAsyncSocket.h"

@interface SocketConnect ()<GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate> {
    Byte m_ucRecvBuffer[MAX_UDP_DATA_LEN];
    unsigned int m_nRecvLen;
    unsigned int m_nRecvFrameLen;
    int m_nRecvType;
}

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;
@property (strong, nonatomic) GCDAsyncSocket *tcpSocket;

@property (strong, nonatomic) NSTimer *searchTimer;
@property (strong, nonatomic) NSTimer *connectTimer;
@property (strong, nonatomic) NSTimer *cmdTimer;

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

- (void)dealloc{
    if ([self.searchTimer isValid]) {
        [self.searchTimer invalidate];
    }
    if ([self.connectTimer isValid]) {
        [self.connectTimer invalidate];
    }
    if ([self.cmdTimer isValid]) {
        [self.cmdTimer invalidate];
    }
}

- (void)startSearchingDevices {
    if ([self.searchTimer isValid]) {
        [self.searchTimer invalidate];
    }
    self.searchTimer = [NSTimer timerWithTimeInterval:searchTimerDelay target:self selector:@selector(searchDelayTimerFired) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.searchTimer forMode:NSRunLoopCommonModes];
    
    [self sendRegisterBroadcast];
}

- (void)searchDelayTimerFired {
    [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(socket_searchDone)}];
}

- (void)sendRegisterBroadcast {
    REGISTER_BROADCAST package = {0};
    package.port = 10001;
    [self.udpSocket sendData:[self buildWithType:CMD_REGISTER_BROADCAST Pbuf:(char *)&package Len:sizeof(REGISTER_BROADCAST)] toHost:@"255.255.255.255" port:9527 withTimeout:-1 tag:0];
}

- (BOOL)connectToHost:(NSString *)host
               onPort:(uint16_t)port
          withTimeout:(NSTimeInterval)timeout
                error:(NSError **)errPtr{
    if ([self.tcpSocket isDisconnected]) {
        return [self.tcpSocket connectToHost:host onPort:port withTimeout:timeout error:errPtr];
    }
    
    return YES;
}

- (BOOL)connectToAddress:(NSData *)address error:(NSError **)errPtr {
    if ([self.tcpSocket isDisconnected]) {
//        return [self.tcpSocket connectToHost:[GCDAsyncUdpSocket hostFromAddress:self.address] onPort:12321 withTimeout:-1 error:errPtr];
    }
    
    return YES;
}

- (void)disconnectToSocketServer{
    if ([self.tcpSocket isConnected]) {
        [self.tcpSocket disconnect];
    }
}

- (void)sendFileData {
    FILE_BEGIN package = {0};
    package.type = 0x00;
    memcpy(package.pic_name, "text_pic", 8);
    package.total = 0;
    [self.tcpSocket writeData:[self buildWithType:CMD_FILE_BEGIN Pbuf:(char *)&package Len:sizeof(FILE_BEGIN)] withTimeout:-1 tag:0];
}

- (void)postNotificationName:(NSString *)name object:(id)anObject{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
    });
}

#pragma mark - private
- (NSData *)buildWithType:(int)type Pbuf:(char *)pbuf Len:(int)len{
    NET_UDP_PACKAGE package = {0};
    package.header = NET_PACK_HEADER;
    package.type = type;
    package.data_len = len;
    if (pbuf && len > 0){
        memcpy((void *)(package.data), (void *)pbuf, len);
    }
    NSMutableData *theData = [NSMutableData data];
    [theData appendBytes:&package length:12 + len];
    return theData;
}

#define NETPACKAGE_HEADER_LEN (sizeof(int))
#define NETPACKAGE_TYPE_LEN (sizeof(int))
#define NETPACKAGE_DATALEN_LEN (sizeof(unsigned int))
- (int)getInt:(Byte *)buffer offset:(int)offset {
    return buffer[offset + 3] << 24 | (buffer[offset + 2] & 0xff) << 16 | (buffer[offset + 1] & 0xff) << 8 | (buffer[offset + 0] & 0xff);
}

- (void)OnReceiveData:(Byte *)buffer length:(unsigned long)len fromAddress:(NSData *)address{
    for(int i = 0; i < len; i++){
        m_ucRecvBuffer[m_nRecvLen++] = buffer[i];
        if(m_nRecvLen == NETPACKAGE_HEADER_LEN){
            int header = [self getInt:&m_ucRecvBuffer[0] offset:0];
            if (header != NET_PACK_HEADER) {
                m_nRecvLen = 0;
                continue;
            }
        }
        else if(m_nRecvLen == NETPACKAGE_HEADER_LEN + NETPACKAGE_TYPE_LEN){
            m_nRecvType = [self getInt:&m_ucRecvBuffer[4]  offset:0];
        }
        else if(m_nRecvLen == NETPACKAGE_HEADER_LEN + NETPACKAGE_TYPE_LEN  + NETPACKAGE_DATALEN_LEN){
            m_nRecvFrameLen = [self getInt:&m_ucRecvBuffer[8]  offset:0];
        }
        
        if(m_nRecvLen == m_nRecvFrameLen + NETPACKAGE_HEADER_LEN + NETPACKAGE_TYPE_LEN + NETPACKAGE_DATALEN_LEN){
            [self parser_dataWithType:m_nRecvType Pbuf:(char *)m_ucRecvBuffer Len:m_nRecvLen fromAddress:address];
            m_nRecvType = 0;
            m_nRecvLen = 0;
            m_nRecvFrameLen = 0;
        }
    }
}

- (void)parser_dataWithType:(int )type Pbuf:(char *)pbuf Len:(long)len fromAddress:(NSData *)address{
    NET_UDP_PACKAGE package = {0};
    memcpy(&package, pbuf, len);
    switch (package.type) {
        case RESP_REGISTER_BROADCAST :{
            REGISTER_BROADCAST_RESP resp = {0};
            memcpy(&resp, package.data, package.data_len);
            [[UserPublic getInstance] addDeviceWithHost:[GCDAsyncUdpSocket hostFromAddress:address] port:resp.port];
        }
            break;
            
        default:
            break;
    }
}

#pragma getter
- (GCDAsyncUdpSocket *)udpSocket {
    if (!_udpSocket) {
        dispatch_queue_t socketQueue = dispatch_queue_create("com.meeting_assistant.socket.udp", DISPATCH_QUEUE_SERIAL);
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
        [_udpSocket bindToPort:10001 error:nil];
        [_udpSocket enableBroadcast:YES error:nil];
        [_udpSocket beginReceiving:nil];
    }
    return _udpSocket;
}

- (GCDAsyncSocket *)tcpSocket {
    if (!_tcpSocket) {
        dispatch_queue_t socketQueue = dispatch_queue_create("com.meeting_assistant.socket.tcp", DISPATCH_QUEUE_SERIAL);
        _tcpSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:socketQueue];
    }
    
    return _tcpSocket;
}

#pragma GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    NSLog(@"udpSocket didReceiveDataFrom: %@\nData:%@", [GCDAsyncUdpSocket hostFromAddress:address], data);
    [self OnReceiveData:(Byte *)[data bytes] length:data.length fromAddress:address];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"udpSocket didSendData.");
}

#pragma GCDAsyncSocketDelegate
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socketDidDisconnect:%@", err);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"socketDidConnectToHost:%@ port:%d", host, port);
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"收到数据:%@",data);
    [sock readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"didWriteDataWithTag:%ld",tag);
    
}
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    return -1;
    
    //    if(elapsed <= READ_TIMEOUT){
    //        return READ_TIMEOUT_EXTENSION;
    //    }
    //
    //    return 0.0;
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    return -1;
}

@end
