//
//  ViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "UIViewController+HUD.h"

@interface ViewController ()<GCDAsyncSocketDelegate, GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic) IBOutlet UITextField *hostTextField;
@property (strong, nonatomic) IBOutlet UITextField *portTextField;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UITextView *logTextView;

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会议小助手";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonAction:(UIButton *)sender {
    if (!self.messageTextField.text.length) {
        [self showHint:@"发送内容不能为空"];
        return;
    }
    if (!self.portTextField.text.length) {
        [self showHint:@"请输入端口号"];
        return;
    }
    
    int port = [self.portTextField.text intValue];
    [self.udpSocket sendData:[self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding] toHost:self.hostTextField.text port:port withTimeout:-1 tag:0];
}

-(void)addTextToLog:(NSString *)str{
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", str, self.logTextView.text];
    [self.logTextView scrollsToTop];
}

#pragma getter
- (GCDAsyncUdpSocket *)udpSocket {
    if (!_udpSocket) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
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
    [self addTextToLog:[NSString stringWithFormat:@"udpSocket didReceiveDataFrom: %@\n%@", [GCDAsyncUdpSocket hostFromAddress:address], receive]];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    [self addTextToLog:@"udpSocket didSendData."];
}

@end
