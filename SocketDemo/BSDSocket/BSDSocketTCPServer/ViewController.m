//
//  ViewController.m
//  BSDSocketTCPServer
//
//  Created by CXY on 16/6/16.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "ViewController.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define ECSOCKETLOG(arg) [self showOnBoard:arg]

@interface ViewController ()
{
    int _peerId;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UIButton *dfdf;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf socketEntry];
    });
}

- (IBAction)sendMsg
{
    if (!_msgField.text) {
        return;
    }
    if (0 == _peerId || -1 == _peerId) {
        return;
    }
    send(_peerId, [_msgField.text UTF8String], 1024, 0);
}

- (void)socketEntry
{
    int err;
    //1.创建socket-套接字
    int fd = socket(AF_INET, SOCK_STREAM  , 0);
    BOOL success = (fd!=-1);
    
    if (success) {
        ECSOCKETLOG(@"-------create socket success--------");
        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_port = htons(1024);
        addr.sin_addr.s_addr = INADDR_ANY;
        //2.绑定套接字-建立地址和套接字的联系
        err = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
        success = (err==0);
    } else {
        close(fd);
    
    }
    if (success) {
        ECSOCKETLOG(@"-------bind(绑定) success-------");
        //3.开始监听端口
        err = listen(fd, 5);
        success = (err==0);
    }
    if (success) {
        ECSOCKETLOG(@"-------listen success-------");
        while (true) {
            struct sockaddr_in peeraddr;
            int peerfd;
            socklen_t addrLen;
            addrLen = sizeof(peeraddr);
            ECSOCKETLOG(@"-------prepare accept-------");
            //4.准备接受连接 线程阻塞
            peerfd = accept(fd, (struct sockaddr *)&peeraddr, &addrLen);
            success = (peerfd!=-1);
            if (success) {
                _peerId = peerfd;
                NSString *log = [NSString stringWithFormat:@"-------accept success,remote address:%s,port:%d-------", inet_ntoa(peeraddr.sin_addr), ntohs(peeraddr.sin_port)];
                ECSOCKETLOG(log);
                char buf[1024];
                ssize_t count;
                size_t len = sizeof(buf);
                do {
                    //5.接收数据
                    count = recv(peerfd, buf, len, 0);
                    NSString *str = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                    NSString *log = [NSString stringWithFormat:@"RECEIVED DATA:%@", str];
                    ECSOCKETLOG(log);
                } while (strcmp(buf, "exit") != 0);
            }
            //6.关闭socket
            close(peerfd);
        }
    }
}

- (void)showOnBoard:(NSString *)str
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.textView.text = [NSString stringWithFormat:@"%@\n%@", weakSelf.textView.text, str];
        [weakSelf.textView scrollRangeToVisible:NSMakeRange(weakSelf.textView.text.length, 1)];
        
    });
}

@end
