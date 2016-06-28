//
//  ViewController.m
//  BSDSocketTCPClient
//
//  Created by CXY on 16/6/16.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "ViewController.h"
#include <sys/socket.h>
#include <netinet/in.h>
#import <arpa/inet.h>


#define ECSOCKETLOG(arg) __weak typeof(self) weakSelf = self;\
                        [weakSelf showOnBoard:arg]

@interface ViewController ()
{
    int _fd;
}
@property (weak, nonatomic) IBOutlet UITextField *serverIPField;
@property (weak, nonatomic) IBOutlet UIButton *connetButtton;

@property (weak, nonatomic) IBOutlet UITextField *inputMsgField;
@property (weak, nonatomic) IBOutlet UITextView *boardTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _boardTextView.layoutManager.allowsNonContiguousLayout = NO;

}

- (IBAction)connetTCPServer
{
    if (!_serverIPField.text) {
        return;
    }
    //        1
    int err;
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    _fd = fd;
    BOOL success = (fd!=-1);
    struct sockaddr_in addr;
    //   2
    if (success) {
        ECSOCKETLOG(@"socket success");
        memset(&addr, 0, sizeof(addr));
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_addr.s_addr = INADDR_ANY;
        err = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
        success = (err==0);
    }
    //3
    if (success) {
        //============================================================================
        struct sockaddr_in peeraddr;
        memset(&peeraddr, 0, sizeof(peeraddr));
        peeraddr.sin_len = sizeof(peeraddr);
        peeraddr.sin_family = AF_INET;
        peeraddr.sin_port = htons(1024);
        //            peeraddr.sin_addr.s_addr=INADDR_ANY;
        //            这个地址是服务器的地址，
        NSString *serverIPAddr = _serverIPField.text;
        peeraddr.sin_addr.s_addr = inet_addr([serverIPAddr UTF8String]);
        socklen_t addrLen;
        addrLen = sizeof(peeraddr);
        ECSOCKETLOG(@"connecting");
        err = connect(fd, (struct sockaddr *)&peeraddr, addrLen);
        success = (err==0);
        if (success) {
            //                struct sockaddr_in addr;
            err = getsockname(fd, (struct sockaddr *)&addr, &addrLen);
            success = (err==0);
            if (success) {
                NSString *msg = [NSString stringWithFormat:@"connect success,local address:%s,port:%d",inet_ntoa(addr.sin_addr),ntohs(addr.sin_port)];
                
                ECSOCKETLOG(msg);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    char buf[1024];
                    ssize_t count;
                    size_t len = sizeof(buf);
                    count = recv(fd, buf, len, 0);
                    do {
                        //5.接收数据
                        NSString *str = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                        NSString *log = [NSString stringWithFormat:@"RECEIVED DATA:%@", str];
                        ECSOCKETLOG(log);
                    } while (strcmp(buf, "exit") != 0);
                });
            }
        } else {
            ECSOCKETLOG(@"connect failed");
        }
    }
    //    ============================================================================
    //3
}

- (IBAction)sendMsg:(id)sender
{
    send(_fd, [_inputMsgField.text UTF8String], 1024, 0);
}

- (void)showOnBoard:(NSString *)str
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.boardTextView.text = [NSString stringWithFormat:@"%@\n%@", weakSelf.boardTextView.text, str];
        
        [weakSelf.boardTextView scrollRangeToVisible:NSMakeRange(weakSelf.boardTextView.text.length, 1)];
        
    });
    
}
@end
