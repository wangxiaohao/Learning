//
//  ViewController.m
//  NSStreamClient
//
//  Created by Chan on 15/3/16.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate>
{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
}
@property (weak, nonatomic) IBOutlet UITextView *showBoard;
- (IBAction)connetToServer:(UIButton *)sender;
- (IBAction)sendDataToServer:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)setupSocketWithHost:(NSString *)hostAddress port:(UInt32)port
{
    //1.convert nsstring to cfstringref
    CFStringRef host = (__bridge CFStringRef)hostAddress;
    CFReadStreamRef rStream;
    CFWriteStreamRef wStream;
    //2.create socket
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &rStream, &wStream);
    //3.convert from cf to ns
    _inputStream = (__bridge NSInputStream *)(rStream);
    _outputStream = (__bridge NSOutputStream *)(wStream);
    //4.set delegate
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    //5.add to runloop
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //6.open stream
    [_inputStream open];
    [_outputStream open];
    
}

- (IBAction)connetToServer:(UIButton *)sender
{
    [self setupSocketWithHost:@"127.0.0.1" port:8888];
}

- (IBAction)sendDataToServer:(UIButton *)sender
{
    [self writeStream];
}

#pragma mark - NSStream delegate method
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone://no response
            NSLog(@"NSStreamEventNone");
            break;
        case NSStreamEventOpenCompleted://stream opened,ready to read&write
            NSLog(@"NSStreamEventOpenCompleted");
            break;
        case NSStreamEventHasBytesAvailable://can read bytes
            NSLog(@"NSStreamEventHasBytesAvailable");
            //do read here
            [self readStream];
            break;
        case NSStreamEventHasSpaceAvailable://can write bytes
            NSLog(@"NSStreamEventHasSpaceAvailable");
            break;
        case NSStreamEventErrorOccurred:// error occurred
            NSLog(@"NSStreamEventErrorOccurred");
            break;
        case NSStreamEventEndEncountered://stream close
            NSLog(@"NSStreamEventEndEncountered");
            break;
 
        default:
            break;
    }
}

- (void)readStream
{
    //建立一个缓冲区 可以放1024个字节
    uint8_t buf[1024];
    
    // 返回实际装的字节数
    NSInteger len = [_inputStream read:buf maxLength:sizeof(buf)];
    
    // 把字节数组转化成字符串
    NSData *data = [NSData dataWithBytes:buf length:len];
    
    // 从服务器接收到的数据
    NSString *recStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    //update ui
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf refreshBoard:recStr];
    });
    
}

- (void)refreshBoard:(NSString *)text
{
    NSString *tmp = _showBoard.text;
    NSString *showText = [NSString stringWithFormat:@"%@\n来自服务器：%@",tmp,text];
    _showBoard.text = showText;
}

- (void)writeStream
{
    NSString *msgToServer = @"hello server!";
    NSData *msgData = [msgToServer dataUsingEncoding:NSUTF8StringEncoding];
    if (_outputStream) {
        NSInteger writtenBytes = [_outputStream write:[msgData bytes] maxLength:msgData.length];
//        if (-1 != writtenBytes) {
//            [self refreshBoard:<#(NSString *)#>]
//        }
    }
   
}
@end
