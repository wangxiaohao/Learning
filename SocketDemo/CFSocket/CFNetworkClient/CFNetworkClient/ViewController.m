//
//  ViewController.m
//  CFNetworkClient
//
//  Created by Chan on 15/3/13.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

const NSInteger kBufferSize = 1024;

@interface ViewController ()
{
    NSMutableData *_receivedData;
}

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UITextView *chatBoard;
- (IBAction)startServer:(UIButton *)sender;
- (IBAction)sendMsgToClient:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)startServer:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf loadDataFromServerWithHost:@"172.25.69.230" port:8888];
    });
}

- (IBAction)sendMsgToClient:(UIButton *)sender
{
//    NSString *msg = @"this is from server";
//    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
   
}

- (void)showMsg:(NSString *)strMsg
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *txt = [NSString stringWithFormat:@"%@\n%@", weakSelf.chatBoard.text, strMsg];
        weakSelf.chatBoard.text = txt;
    });
    
}

- (void)loadDataFromServerWithHost:(NSString *)host port:(NSUInteger)port
{
    // Keep a reference to self to use for controller callbacks
    //
    CFStreamClientContext ctx = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    // Get callbacks for stream data, stream end, and any errors
    //
    CFOptionFlags registeredEvents = (kCFStreamEventHasBytesAvailable | kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred);
    
    // Create a read-only socket
    //
    CFReadStreamRef readStream;
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)host, (int)port, &readStream, NULL);
    
    // Schedule the stream on the run loop to enable callbacks
    //
    if (CFReadStreamSetClient(readStream, registeredEvents, socketCallback, &ctx)) {
        CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    } else {
        [self showMsg:@"Failed to assign callback method"];
        return;
    }
    
    // Open the stream for reading
    //
    if (!CFReadStreamOpen(readStream)) {
        [self showMsg:@"Failed to open read stream"];
        return;
    }
    
    CFErrorRef error = CFReadStreamCopyError(readStream);
    if (error != NULL) {
        if (CFErrorGetCode(error) != 0) {
            NSString * errorInfo = [NSString stringWithFormat:@"Failed to connect stream; error '%@' (code %ld)", (__bridge NSString*)CFErrorGetDomain(error), CFErrorGetCode(error)];
            [self showMsg:errorInfo];
        }
        CFRelease(error);
        return;
    }
    [self showMsg:[NSString stringWithFormat:@"Successfully connected to %@", host]];
    // Start processing
    CFRunLoopRun();

}
- (void)loadDataFromServerWithURL:(NSURL *)url
{
    NSString * host = [url host];
    NSInteger port = [[url port] integerValue];
    [self loadDataFromServerWithHost:host port:port];
}


- (void)didReceiveData:(NSData *)data {
    if (_receivedData == nil) {
        _receivedData = [[NSMutableData alloc] init];
    }
    [_receivedData appendData:data];
    // Update UI
    NSString * resultsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMsg:resultsString];
}

- (void)didFinishReceivingData
{
    
}

void socketCallback(CFReadStreamRef stream, CFStreamEventType event, void * myPtr)
{
    ViewController * controller = (__bridge ViewController *)myPtr;
    switch(event) {
        case kCFStreamEventHasBytesAvailable: {
            // Read bytes until there are no more
            //
            while (CFReadStreamHasBytesAvailable(stream)) {
                UInt8 buffer[kBufferSize];
                int numBytesRead = (int)CFReadStreamRead(stream, buffer, kBufferSize);
                [controller didReceiveData:[NSData dataWithBytes:buffer length:numBytesRead]];
            }
            break;
        }
        case kCFStreamEventErrorOccurred: {
            CFErrorRef error = CFReadStreamCopyError(stream);
            if (error != NULL) {
                if (CFErrorGetCode(error) != 0) {
                    NSString * errorInfo = [NSString stringWithFormat:@"Failed while reading stream; error '%@' (code %ld)", (__bridge NSString*)CFErrorGetDomain(error), CFErrorGetCode(error)];
                    [controller showMsg:errorInfo];
                }
                CFRelease(error);
            }
            break;
        }
        case kCFStreamEventEndEncountered:
            // Finnish receiveing data
            //
            [controller didFinishReceivingData];
            // Clean up
            //
            CFReadStreamClose(stream);
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFRunLoopStop(CFRunLoopGetCurrent());
            break;
        default:
            break;
    }
}
@end
