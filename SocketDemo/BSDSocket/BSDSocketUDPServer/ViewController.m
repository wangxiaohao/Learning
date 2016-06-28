//
//  ViewController.m
//  BSDSocketUDPServer
//
//  Created by CXY on 16/6/16.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "ViewController.h"

/*
 *UDP/IP应用编程接口（API）
 *服务器的工作流程：首先调用socket函数创建一个Socket，然后调用bind函数将其与本机
 *地址以及一个本地端口号绑定，接收到一个客户端时，服务器显示该客户端的IP地址，并将字串
 *返回给客户端。
 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf threadEntry];
    });

}

- (void)threadEntry
{
    int ser_sockfd;
    int len;
    //int addrlen;
    socklen_t addrlen;
    char seraddr[100];
    struct sockaddr_in ser_addr;
    /*建立socket*/
    ser_sockfd = socket(AF_INET,SOCK_DGRAM,0);
    if(ser_sockfd<0)
    {
        printf("I cannot socket success\n");
    }
    /*填写sockaddr_in 结构*/
    addrlen = sizeof(struct sockaddr_in);
    bzero(&ser_addr,addrlen);
    ser_addr.sin_family = AF_INET;
    ser_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    ser_addr.sin_port = htons(1024);
    /*绑定客户端*/
    if(bind(ser_sockfd,(struct sockaddr *)&ser_addr,addrlen)<0)
    {
        printf("connect");
    }
    while(1)
    {
        bzero(seraddr,sizeof(seraddr));
        len =recvfrom(ser_sockfd,seraddr,sizeof(seraddr),0,(struct sockaddr*)&ser_addr,&addrlen);
        /*显示client端的网络地址*/
        printf("receive from %s\n", inet_ntoa(ser_addr.sin_addr));
        /*显示客户端发来的字串*/
        printf("recevce:%s",seraddr);
        /*将字串返回给client端*/
        sendto(ser_sockfd,seraddr,len,0,(struct sockaddr*)&ser_addr,addrlen);
    }
}

@end
