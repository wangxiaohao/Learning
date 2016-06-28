//
//  ViewController.h
//  SocketServer
//
//  Created by Chan on 15/3/13.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@protocol SocketServerDelegate;

@interface SocketServer : NSObject
{
    CFSocketRef _socket;
}
@property (retain, nonatomic) id<SocketServerDelegate> delegate;
- (void)startServer;
- (void)sendMessage:(NSString *)msg;
@end

@protocol SocketServerDelegate <NSObject>

- (void)showMsg:(NSString*)strMsg;

@end