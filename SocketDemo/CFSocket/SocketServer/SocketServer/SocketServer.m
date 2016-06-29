//
//  ViewController.h
//  SocketServer
//
//  Created by Chan on 15/3/13.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import "SocketServer.h"
#import "ViewController.h"

static CFWriteStreamRef outputStream;

@implementation SocketServer
/**
 *  创建socket并初始化（绑定端口并监听）
 *
 *  @return  0:失败 1：成功
 */
- (int)setupSocket
{
    CFSocketContext sockContext = {0, // 结构体的版本，必须为0
        (__bridge void *)(self),
        NULL, // 一个定义在上面指针中的retain的回调， 可以为NULL
        NULL,
        NULL};
    
    /**
     *  create the socket
     *
     *  @param kCFAllocatorDefault     <#kCFAllocatorDefault description#>
     *  @param PF_INET                 protocol Family:协议族，协议族决定了socket的地址类型，如AF_INET决定了要用ipv4地址（32位）与端口号（16位）的组合。
     *  @param SOCK_STREAM             socket type：有SOCKET_DGRAM ,SOCK_RAW,SOCK_STREAM等
     *  @param IPPROTO_TCP              指定协议：tcp ,udp,stcp,sudp 注意：socket type与协议类型不可随意组合，SOCK_STREAM与tcp...
     *  @param kCFSocketAcceptCallBack 回调类型为接受客户端连接后回调
     *  @param TCPServerAcceptCallBack 回调函数
     *  @param sockContext             socket上下文
     *
     *  @return created socket
     */
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerAcceptCallBack, &sockContext);
    if (NULL == _socket) {//create socket failed
        NSLog(@"Cannot create socket!");
        [self sendMessage:@"Cannot create socket!"];

        return 0;
    }
    
    int optval = 1;
    /**
     *  setsockopt() manipulate the options associated with a socket.  Options may exist at
     multiple protocol levels; they are always present at the uppermost ``socket'' level.
     * CFSocketGetNative(cfsocketref s):Return The native socket associated with s. If s has been invalidated, returns -1, INVALID_SOCKET. CFSocketNativeHandle :Type for the platform-specific native socket handle.特定平台的本地socket句柄
     *  @param _socket <#_socket description#>
     *
     *  @return <#return value description#>
     */
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR, // 允许重用本地地址和端口
               (void *)&optval, sizeof(optval));
    /**
     *  struct sockaddr
     {
     unsigned short sa_family;//addressfamily,AF_xxx
     char sa_data[14];//14bytesofprotocoladdress
        * };
     sa_family是地址家族，一般都是“AF_xxx”的形式。通常大多用的是都是AF_INET,代表TCP/IP协议族。
     sa_data是14字节协议地址。
     此数据结构用做bind、connect、recvfrom、sendto等函数的参数，指明地址信息。但一般编程中并不直接针对此数据结构操作，而是使用另一个与sockaddr等价的* 数据结构
     /*
     * Socket address, internet style.
 
     struct sockaddr_in
     
     {
     __uint8_t	sin_len;
     sa_family_t sin_family;//Addressfamily一般来说AF_INET（地址族）PF_INET（协议族）
    
    uin_port_t sin_port;//Portnumber(必须要采用网络数据格式,普通数字可以用htons()函数转换成网络数据格式的数字)
    
    struct in_addr sin_addr;//Internetaddress
    
    uchar sin_zero[8];/*Samesizeasstructsockaddr没有实际意义,只是为了　跟SOCKADDR结构在内存中对齐
    
     };
     */
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));//addr4内存置0
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(1024);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    //Creates an immutable CFData object using data copied from a specified byte buffer.
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
    //CFSocketSetAddress(_socket, address):Binds a local address to a CFSocket object and configures it for listening.
    //绑定端口并监听
    if (kCFSocketSuccess != CFSocketSetAddress(_socket, address))
    {
        NSLog(@"Bind to address failed!");
        [self showMsgOnMainPage:@"Bind to address failed!"];
        if (_socket)
            CFRelease(_socket);// release the socket
        _socket = NULL;
        return 0;
    }
    
    
//    //// PART 3: Find out what port kernel assigned to our socket
//    // We need it to advertise our service via Bonjour
//    NSData *socketAddressActualData = (NSData *)CFBridgingRelease(CFSocketCopyAddress(_socket));
//    // Convert socket data into a usable structure
//    struct sockaddr_in socketAddressActual;
//    memcpy(&socketAddressActual, [socketAddressActualData bytes],
//           [socketAddressActualData length]);
//    int assignedPort = ntohs(socketAddressActual.sin_port);
    
    
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();//get current thread's runloop
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);//基于端口的输入源
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);//将源添加到runloop中
    CFRelease(source);//cf框架手动释放内存
    
    return 1;
}

- (void)sendMessage:(NSString *)msg
{
    const char *str = [msg UTF8String];
    uint8_t * uin8b = (uint8_t *)str;
    if (outputStream != NULL)
    {
        CFIndex flag = CFWriteStreamWrite(outputStream, uin8b, strlen(str) + 1);
        if (-1 == flag) {
            NSLog(@"Cannot send data!");
            [self showMsgOnMainPage:@"Cannot send data!"];
            return;
        }
        NSLog(@"send data successfully!");
        [self showMsgOnMainPage:msg];
    }
    else {
        NSLog(@"Cannot send data!");
        [self showMsgOnMainPage:@"Cannot send data!"];
        return;
    }
    
}


- (void)startServer
{
    int res = [self  setupSocket];
    if (!res) {
        [self showMsgOnMainPage:@"startServer failed!"];
        return;
    }
    [self showMsgOnMainPage:@"startServer successfully!"];
}

- (void)showMsgOnMainPage:(NSString*)strMsg
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMsg:)]) {
        [self.delegate showMsg:strMsg];
    }
    
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// socket回调函数
static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (kCFSocketAcceptCallBack == type)
    {
        // 本地套接字句柄
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t nameLen = sizeof(name);
        if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)name, &nameLen)) {
            NSLog(@"error");
            exit(1);
        }
        CFReadStreamRef iStream;
        CFWriteStreamRef oStream;
        // 创建一个可读写的socket连接
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &iStream, &oStream);
        if (iStream && oStream)
        {
            CFStreamClientContext streamContext = {0, info, NULL, NULL};
            if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable,readStream, &streamContext))
            {
                exit(1);
            }
            
            if (!CFWriteStreamSetClient(oStream, kCFStreamEventCanAcceptBytes, writeStream, &streamContext))
            {
                exit(1);
            }
            CFReadStreamScheduleWithRunLoop(iStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
            CFWriteStreamScheduleWithRunLoop(oStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
            CFReadStreamOpen(iStream);
            CFWriteStreamOpen(oStream);
        } else
        {
            close(nativeSocketHandle);
        }
    }
}
// 读取数据
void readStream(CFReadStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo)
{
    UInt8 buff[1024];
    CFReadStreamRead(stream, buff, 1025);//读取数据到缓冲区中
    
    ///根据delegate显示到主界面去
    NSString *strMsg = [[NSString alloc]initWithFormat:@"客户端传来消息：%s",buff];
    SocketServer *info = (__bridge SocketServer *)clientCallBackInfo;
    [info showMsgOnMainPage:strMsg];
}
void writeStream (CFWriteStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo)
{
    outputStream = stream;
}
@end
