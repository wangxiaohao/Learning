//
//  ViewController.m
//  GCDAsyncSocketDemo
//
//  Created by CXY on 16/6/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

#define PROTOCOL_VERSION 1.0

const NSInteger kMaxReconnectTime = 5;


@interface ViewController ()<GCDAsyncSocketDelegate>
{}
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger reconnectTime;
@property (strong, nonatomic) NSTimer *reconnectTimer;
@property (weak) IBOutlet NSTextField *msField;
- (IBAction)sendMsgToServer:(NSButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.socket connectToHost:@"127.0.0.1" onPort:1024 error:nil];
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
//    [self.socket disconnect];
}

- (void)dealloc {
    [self.socket disconnect];
}

- (IBAction)sendMsgToServer:(NSButton *)sender {
    if (!_msField.stringValue) {
        return;
    }
    [self sendMsg:@"1" body:_msField.stringValue];
}

- (void)reconnection {
    [self.socket connectToHost:@"127.0.0.1" onPort:1024 error:nil];
}

- (void)sendMsg:(NSString *)reqType body:(NSString *)reqBody {
    /* 这个\r\n是socket消息的边界符，是为了防止发生消息黏连，没有\r\n的话，可能由于某种原因，后端会收到两条socket请求，但是后端不知道怎么拆分这两个请求
     GCDAsyncSocket不支持自定义边界符，它提供了四种边界符供你使用\r\n、\r、\n、空字符串
     */
    
    NSString *msg = [NSString stringWithFormat:@"{\"version\":%f,\"reqType\":%@,\"body\":\"%@\"}\r\n", PROTOCOL_VERSION, reqType, reqBody];
    //发送数据
    [self.socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    //在写之后，需要再调用读方法，这样才能收到你发出请求后从服务器那边收到的数据
    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:50000 tag:0];
}

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port {
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    _status= -1;
    
    if(_reconnectTime>=0 && _reconnectTime <= kMaxReconnectTime) {
        
        [_reconnectTimer invalidate];
        
        _reconnectTimer = nil;
        
        int time =pow(2, _reconnectTime);
        
        _reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(reconnection) userInfo:nil repeats:NO];
        
        _reconnectTime++;
        
        NSLog(@"socket did reconnection,after %ds try again",time);
        
    }else{
        _reconnectTime = 0;
        NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
        
    }
}


- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    
}

- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    
}


@end
