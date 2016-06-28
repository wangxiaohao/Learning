//
//  ViewController.m
//  BSDSocketUDPClient
//
//  Created by CXY on 16/6/16.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "ViewController.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()
{
    int _sockfd;
}
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *serverIPField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (IBAction)sendMsg
{
    if (!_serverIPField.text) {
        return;
    }
    if (!_msgField.text) {
        return;
    }
    int cli_sockfd;
    int len;
    socklen_t addrlen;
    const char *seraddr;
    struct sockaddr_in cli_addr;
    char *buffer;
    seraddr = [_serverIPField.text UTF8String];
    //1. 建立socket
    cli_sockfd = socket(AF_INET,SOCK_DGRAM,0);
    if(cli_sockfd < 0)
    {
        printf("I cannot socket success\n");
        return;
    }
    _sockfd = cli_sockfd;
    /* 填写sockaddr_in*/
    addrlen = sizeof(struct sockaddr_in);
    bzero(&cli_addr,addrlen);
    cli_addr.sin_family = AF_INET;
    cli_addr.sin_addr.s_addr = inet_addr(seraddr);
    //cli_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    cli_addr.sin_port = htons(1024);
    buffer = (char *)[_msgField.text UTF8String];
    len = (int)strlen(buffer);
    /* 将字符串传送给server端*/
    sendto(cli_sockfd,buffer,len,0,(struct sockaddr*)&cli_addr,addrlen);
    /* 接收server端返回的字符串*/
    len = (int)recvfrom(cli_sockfd,buffer,sizeof(buffer),0,(struct sockaddr*)&cli_addr,&addrlen);
    //printf("receive from %s\n",inet_ntoa(cli_addr.sin_addr));
    printf("receive: %s",buffer);
    close(_sockfd);
}

- (void)dealloc
{
    
}

@end
