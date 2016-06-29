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

const NSInteger kMaxReconnectTime = 5;//重连最大次数


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

#pragma mark 重连
- (void)reconnection {
    [self.socket connectToHost:@"127.0.0.1" onPort:1024 error:nil];
}

#pragma mark 发送消息
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

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port {
    //建立连接成功时的回调，这里做心跳处理
    /*一、长连接与短连接
     长连接: 指在一个TCP连接上可以连续发送多个数据包，
     在TCP连接保持期间，如果没有数据包发送，需要双方发检测包以维持此连接;
     一般需要自己做在线维持。
     短连接: 指通信双方有数据交互时，就建立一个TCP连接，数据发送完成后，则断开此TCP连接;
     一般银行都使用短连接。
     它的优点是：管理起来比较简单，存在的连接都是有用的连接，不需要额外的控制手段
     
     比如http的，只是连接、请求、关闭，过程时间较短,服务器若是一段时间内没有收到请求即可关闭连接。
     其实长连接是相对于通常的短连接而说的，也就是长时间保持客户端与服务端的连接状态。
     
     长连接与短连接的操作过程
     通常的短连接操作步骤是：
     连接→数据传输→关闭连接；
     
     而长连接通常就是：
     连接→数据传输→保持连接(心跳)→数据传输→保持连接(心跳)→……→关闭连接；
     
     这就要求长连接在没有数据通信时，定时发送数据包(心跳)，以维持连接状态，
     短连接在没有数据传输时直接关闭就行了
     
     什么时候用长连接，短连接？
     长连接多用于操作频繁，点对点的通讯，而且连接数不能太多情况。
     每个TCP连接都需要三步握手，这需要时间，如果每个操作都是先连接，再操作的话那么处理速度会降低很多，
     所以每个操作完后都不断开，下次次处理时直接发送数据包就OK了，不用建立TCP连接。
     
     例如：数据库的连接用长连接， 
     如果用短连接频繁的通信会造成socket错误，而且频繁的socket 创建也是对资源的浪费。*/
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    //建立连接失败时的回调，这里做重连处理
    _status= -1;
    if(_reconnectTime>=0 && _reconnectTime <= kMaxReconnectTime) {
        [_reconnectTimer invalidate];
        _reconnectTimer = nil;
        int time =pow(2, _reconnectTime);
        _reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(reconnection) userInfo:nil repeats:NO];
        _reconnectTime++;
        NSLog(@"socket did reconnection,after %ds try again",time);
    } else {
        _reconnectTime = 0;
        NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    }
}


- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    
}

- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    
}


@end
