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

#define udpPortSelf          10001

#define searchTimerDelay     5.0
#define connectTimerDelay    5.0
#define cmdTimerDelay        5.0


@interface TCPSendFileData : AppType

@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *deviceName;
@property (assign, nonatomic) int type;

@end

@implementation TCPSendFileData



@end

@interface SocketConnect ()<GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate> {
    Byte m_ucRecvBuffer[MAX_UDP_DATA_LEN];
    unsigned int m_nRecvLen;
    unsigned int m_nRecvFrameLen;
    int m_nRecvType;
    
    NSString *cmdHost;//发送cmd命令的名牌地址
    NSUInteger indexToSend;
}

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;
@property (strong, nonatomic) GCDAsyncSocket *tcpSocket;
@property (strong, nonatomic) NSMutableArray *tcpSendFiles;

@property (strong, nonatomic) NSTimer *searchTimer;
@property (strong, nonatomic) NSTimer *connectTimer;
@property (strong, nonatomic) NSTimer *cmdTimer;

@property (strong, nonatomic) dispatch_semaphore_t send_single_file_lock;

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
        self.send_single_file_lock = dispatch_semaphore_create(1);
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

- (void)stopSearchingDevices {
    if ([self.searchTimer isValid]) {
        [self.searchTimer invalidate];
    }
}

- (void)operationLightOpen:(BOOL)open host:(NSString *)host port:(int)port {
    OPERATION_LIGHT package = {0};
    package.result = open ? 0x00 : 0x01;
    [self sendUDPCMD:open ? CMD_OPERATION_LIGHT_OPEN : CMD_OPERATION_LIGHT_CLOSE Pbuf:(char *)&package Len:sizeof(OPERATION_LIGHT) host:host port:port];
}

- (void)updateDeviceName:(NSString *)name imageData:(NSData *)data host:(NSString *)host {
    [self prepareForSendingImageData];
    TCPSendFileData *m_data = [TCPSendFileData new];
    m_data.data = [data copy];
    m_data.host = host;
    m_data.imageName = @"SL0000.bmp";
    m_data.deviceName = [name copy];
    m_data.type = 0x00;
    [self.tcpSendFiles addObject:m_data];
    [self preparedToSendImageData:host];
}

- (void)updateMeetingSummary:(NSArray *)imageArray host:(NSString *)host {
    [self prepareForSendingImageData];
    for (NSUInteger i = 0; i < imageArray.count; i++) {
        UIImage *image = imageArray[i];
        TCPSendFileData *m_data = [TCPSendFileData new];
        m_data.data = UIImageJPEGRepresentation(image, 1.0);
        m_data.host = host;
        m_data.imageName = [NSString stringWithFormat:@"SL%04d.bmp", (int)i + 1];
        m_data.type = i == 0 ? 0x01 : 0x02;
        [self.tcpSendFiles addObject:m_data];
    }
    [self preparedToSendImageData:host];
}

- (void)prepareForSendingImageData {
    if ([self.connectTimer isValid]) {
        [self.connectTimer invalidate];
    }
    indexToSend = 0;
    [self.tcpSendFiles removeAllObjects];
}

- (void)preparedToSendImageData:(NSString *)host {
    self.connectTimer = [NSTimer timerWithTimeInterval:connectTimerDelay target:self selector:@selector(connectDelayTimerFired) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
    [self connectToHost:host onPort:12321 withTimeout:connectTimerDelay error:nil];
}

- (void)postNotificationName:(NSString *)name object:(id)anObject{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
    });
}

#pragma mark - private
- (void)searchDelayTimerFired {
    [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(socket_searchDone)}];
}

- (void)cmdDelayTimerFired {
    [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(socket_cmdTimeout)}];
}

- (void)connectDelayTimerFired {
    [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(socket_connectTimeout)}];
}

- (void)sendRegisterBroadcast {
    REGISTER_BROADCAST package = {0};
    package.port = udpPortSelf;
    [self.udpSocket sendData:[self udpBuildWithType:CMD_REGISTER_BROADCAST Pbuf:(char *)&package Len:sizeof(REGISTER_BROADCAST)] toHost:@"255.255.255.255" port:9527 withTimeout:-1 tag:0];
}

- (void)sendRegisterResult:(BOOL)success host:(NSString *)host port:(int)port{
    REGISTER_RESULT package = {0};
    package.result = success ? 0x01 : 0x00;
    [self.udpSocket sendData:[self udpBuildWithType:CMD_REGISTER_RESULT Pbuf:(char *)&package Len:sizeof(REGISTER_RESULT)] toHost:host port:port withTimeout:-1 tag:0];
}

- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr{
    if ([self.tcpSocket isDisconnected]) {
        return [self.tcpSocket connectToHost:host onPort:port withTimeout:timeout error:errPtr];
    }
    
    return YES;
}

- (void)disconnectToSocketServer{
    if ([self.tcpSocket isConnected]) {
        [self.tcpSocket disconnect];
    }
}

- (void)sendUDPCMD:(int)type Pbuf:(char *)pbuf Len:(int)len host:(NSString *)host port:(int)port{
    if ([self.cmdTimer isValid]) {
        [self.cmdTimer invalidate];
    }
    cmdHost = [host copy];
    self.cmdTimer = [NSTimer timerWithTimeInterval:cmdTimerDelay target:self selector:@selector(cmdDelayTimerFired) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.cmdTimer forMode:NSRunLoopCommonModes];
    [self.udpSocket sendData:[self udpBuildWithType:type Pbuf:pbuf Len:len] toHost:host port:port withTimeout:-1 tag:0];
}

- (void)doSendTCPFileData {
    if (indexToSend >= self.tcpSendFiles.count) {
        [self disconnectToSocketServer];
        if (self.tcpSendFiles.count == 1) {
            TCPSendFileData *fileData = self.tcpSendFiles[0];
            if (fileData.deviceName) {
                //设置设备显示名称图片
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[UserPublic getInstance] updateDeviceShowName:fileData.deviceName host:fileData.host];
                });
            }
        }
        indexToSend = 0;
        [self.tcpSendFiles removeAllObjects];
        [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(socket_tcpSendDone)}];
        return;
    }
    
    TCPSendFileData *fileData = self.tcpSendFiles[indexToSend];
    NSData *data = fileData.data;
    int countOnce = (MAX_TCP_DATA_LEN - 20);
    int total = (int)data.length / countOnce + (data.length % countOnce == 0 ? 0 : 1);
    FILE_BEGIN begin = {0};
    begin.type = fileData.type;
    memcpy(begin.pic_name, [fileData.imageName UTF8String], fileData.imageName.length);
    begin.total = total;
    
    [self tcpWriteData:[self tcpBuildWithType:CMD_FILE_BEGIN Pbuf:(char *)&begin Len:sizeof(FILE_BEGIN)]];
    
    for (int i = 0; i < total; i++) {
        FILE_CONTENT content = {0};
        content.seq = i;
        if (i == total - 1) {
            content.len = (int)data.length - countOnce * i;
        }
        else {
            content.len = countOnce;
        }
        memcpy(content.buf, data.bytes + i * countOnce, content.len);
        [self tcpWriteData:[self tcpBuildWithType:CMD_FILE_CONTENT Pbuf:(char *)&content Len:8 + content.len]];
    }
    [self tcpWriteData:[self tcpBuildWithType:CMD_FILE_FINISH Pbuf:NULL Len:0]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"等待单个文件发送完成...");
        dispatch_semaphore_wait(self.send_single_file_lock, DISPATCH_TIME_FOREVER);
        NSLog(@"单个文件发送已完成。");
        dispatch_semaphore_signal(self.send_single_file_lock);
        indexToSend++;
        [self doSendTCPFileData];
    });
}

- (void)tcpWriteData:(NSData *)data {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"准备执行tcp数据写入...");
        dispatch_semaphore_wait(self.send_single_file_lock, DISPATCH_TIME_FOREVER);
        NSLog(@"tcp数据写入中...");
        [self.tcpSocket writeData:data withTimeout:-1 tag:0];
    });
}

- (NSData *)udpBuildWithType:(int)type Pbuf:(char *)pbuf Len:(int)len{
    NET_UDP_PACKAGE package = {0};
    package.header = NET_PACK_HEADER;
    package.type = type;
    package.data_len = len;
    if (pbuf && len > 0){
        memcpy(package.data, pbuf, len);
    }
    NSMutableData *theData = [NSMutableData data];
    [theData appendBytes:&package length:12 + len];
    NSLog(@"build data:%@", theData);
    return theData;
}

- (NSData *)tcpBuildWithType:(int)type Pbuf:(char *)pbuf Len:(int)len{
    NET_TCP_PACKAGE package = {0};
    package.header = NET_PACK_HEADER;
    package.type = type;
    package.data_len = len;
    if (pbuf && len > 0){
        memcpy(package.data, pbuf, len);
    }
    NSMutableData *theData = [NSMutableData data];
    [theData appendBytes:&package length:12 + len];
    NSLog(@"build data:%@", len < 100 ? theData : @(len));
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

- (void)parser_dataWithType:(int )type Pbuf:(char *)pbuf Len:(long)len fromAddress:(NSData *)address {
    NET_UDP_PACKAGE package = {0};
    memcpy(&package, pbuf, len);
    
    if (package.type != RESP_REGISTER_BROADCAST) {
        if ([self.searchTimer isValid]) {
            //搜索发现设备期间对其他命令不做响应
            return;
        }
    }
    switch (package.type) {
        case RESP_REGISTER_BROADCAST :{
            if ([self.searchTimer isValid]) {
                REGISTER_BROADCAST_RESP resp = {0};
                memcpy(&resp, package.data, package.data_len);
                NSString *host = [GCDAsyncUdpSocket hostFromAddress:address];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    BOOL result = [[UserPublic getInstance] addDeviceWithHost:host port:resp.port];
                    [self sendRegisterResult:result host:host port:resp.port];
                });
            }
        }
            break;
            
        case RESP_OPERATION_LIGHT_OPEN:
        case RESP_OPERATION_LIGHT_CLOSE:{
            if ([self.cmdTimer isValid]) {
                [self.cmdTimer invalidate];
            }
            OPERATION_LIGHT_RESP resp = {0};
            memcpy(&resp, package.data, package.data_len);
            
            BOOL result = (resp.result == 0x00);
            BOOL lighted = NO;
            if (package.type == RESP_OPERATION_LIGHT_OPEN && result) {
                lighted = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [[UserPublic getInstance] updateDeviceLighted:lighted host:cmdHost];
            });
            
            [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(package.type), @"result" : @(result)}];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter
- (GCDAsyncUdpSocket *)udpSocket {
    if (!_udpSocket) {
        dispatch_queue_t socketQueue = dispatch_queue_create("com.meeting_assistant.socket.udp", DISPATCH_QUEUE_SERIAL);
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
        [_udpSocket bindToPort:udpPortSelf error:nil];
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

- (NSMutableArray *)tcpSendFiles {
    if (!_tcpSendFiles) {
        _tcpSendFiles = [NSMutableArray new];
    }
    return _tcpSendFiles;
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    NSLog(@"udpSocket didReceiveDataFrom: %@\nData:%@", [GCDAsyncUdpSocket hostFromAddress:address], data);
    [self OnReceiveData:(Byte *)[data bytes] length:data.length fromAddress:address];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"udpSocket didSendData.");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"udpSocket didNotSendData:%@", error);
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  *)error {
    NSLog(@"udpSocketDidClose:%@", error);
    _udpSocket = nil;
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socketDidDisconnect:%@", err);
    if ([self.connectTimer isValid]) {
        [self.connectTimer invalidate];
        [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(socket_connectFailed)}];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"socketDidConnectToHost:%@ port:%d", host, port);
    if ([self.connectTimer isValid]) {
        [self.connectTimer invalidate];
//        [self postNotificationName:kNotification_Socket object:@{@"cmd" : @(socket_connectDone)}];
        [self doSendTCPFileData];
    }
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"收到数据:%@",data);
    [sock readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"tcp socket did write data:%ld",tag);
    dispatch_semaphore_signal(self.send_single_file_lock);
}
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    NSLog(@"tcp socket didWritePartialDataOfLength:%ld tag:%ld", partialLength, tag);
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    return -1;
    
    //    if(elapsed <= READ_TIMEOUT){
    //        return READ_TIMEOUT_EXTENSION;
    //    }
    //
    //    return 0.0;
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    
    return -1;
}

@end
