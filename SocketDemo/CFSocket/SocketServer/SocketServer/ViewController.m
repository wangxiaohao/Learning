//
//  ViewController.m
//  SocketServer
//
//  Created by Chan on 15/3/13.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "SocketServer.h"

@interface ViewController ()<SocketServerDelegate>
{
    SocketServer *_server;
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
    SocketServer *server = [[SocketServer alloc] init];
    server.delegate = self;
    _server = server;
    _chatBoard.layoutManager.allowsNonContiguousLayout = NO;
}

- (IBAction)startServer:(UIButton *)sender
{
    [_server startServer];
}

- (IBAction)sendMsgToClient:(UIButton *)sender
{
    NSString *msg = @"this is from server";
//    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [_server sendMessage:msg];
   
}

- (void)showMsg:(NSString *)strMsg
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *txt = [NSString stringWithFormat:@"%@\n%@", weakSelf.chatBoard.text,strMsg];
        weakSelf.chatBoard.text = txt;
        [weakSelf.chatBoard scrollRangeToVisible:NSMakeRange(weakSelf.chatBoard.text.length, 1)];
    });
    
}

@end
