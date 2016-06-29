---
layout: post
title: "iOS Socket编程"
date: 2016-04-30
categories: 网络
tags: [socket编程]


---

### 什么是Socket

提起socket，我们不得不先看看TCP/IP协议族。

下图显示了TCP/IP协议四层之间的关系：

<!-- more -->
![img](http://7xql77.com1.z0.glb.clouddn.com/socket_concept.jpg)

其中，Socket是'应用层与TCP/IP协议族通信的中间软件抽象层，它是一组接口'，在设计模式中，Socket就是一个门面模式，它把复杂的TCP/IP协议族隐藏在了Scoket接口的后面，让Socket去组织数据，以符合指定的协议。

### TCP与UDP协议

1. TCP协议：面向连接、传输可靠(保证数据正确性,保证数据顺序)、用于传输大量数据(流模式)、速度慢，建立连接需要开销较多(时间，系统资源)。

2. UDP协议：面向非连接、传输不可靠、用于传输少量数据(数据包模式)、速度快。

3. TCP三次握手和四次挥手

	* TCP三次握手

		所谓三次握手(Three-way Handshake)，是指建立一个TCP连接时，需要客户端和服务器总共发送3个包。三次握手的目的是连接服务器指定端口，建立TCP连接,并同步连接双方的序列号和确认号并交换 TCP 窗口大小信息.在socket编程中，客户端执行connect()时。将触发三次握手。 
	
		![img](http://7xql77.com1.z0.glb.clouddn.com/tcp3wo.png)
		
		首先了解一下几个标志，SYN（synchronous），同步标志；ACK (Acknowledgement），即确认标志；seq(Sequence Number)，序列号的意思；另外还有四次握手的fin(final)，表示结束标志。
	
		第一次握手：客户端发送一个TCP的SYN标志位置1的包指明客户打算连接的服务器的端口，以及初始序号X,保存在包头的序列号(Sequence Number)字段里。
	
		第二次握手：服务器发回确认包(ACK)应答。即SYN标志位和ACK标志位均为1同时，将确认序号(Acknowledgement Number)设置为客户的序列号加1以，即X+1。
	
		第三次握手：客户端再次发送确认包(ACK) SYN标志位为0，ACK标志位为1。并且把服务器发来ACK的序号字段+1，放在确定字段中发送给对方.并且在数据段放写序列号的+1。
		
	* TCP四次挥手
	
		TCP的连接的拆除需要发送四个包，因此称为四次挥手(four-way handshake)。客户端或服务器均可主动发起挥手动作，在socket
	
		编程中，任何一方执行close()操作即可产生挥手操作。

		![img](http://7xql77.com1.z0.glb.clouddn.com/tcp4hui.png)

		为什么连接的时候是三次握手，关闭的时候却是四次挥手？
	
		因为当Server端收到Client端的SYN连接请求报文后，可以直接发送SYN+ACK报文。其中ACK报文是用来应答的，SYN报文是用来同步的。但是关闭连接时，当Server端收到FIN报文时，很可能并不会立即关闭SOCKET，所以只能先回复一个ACK报文，告诉Client端，"你发的FIN报文我收到了"。只有等到我Server端所有的报文都发送完了，我才能发送FIN报文，因此不能一起发送。故需要四步握手。

### Socket在iOS上的实现

iOS Socket编程层次结构分为三层：

`BSD socket` `CFNetwork` 和 `NSStream`

1. 基于C的BSD socket

	BSD socket API 和 winsock API 接口大体差不多，下面将列出比较常用的 API：
	
	* socket() 创建一个新的确定类型的套接字，类型用一个整型数值标识（文件描述符），并为它分配系统资源。
	
	* bind() 一般用于服务器端，将一个套接字与一个套接字地址结构相关联，比如，一个指定的本地端口和IP地址。
	
	* listen() 用于服务器端，使一个绑定的TCP套接字进入监听状态。
	
	* connect() 用于客户端，为一个套接字分配一个自由的本地端口号。 如果是TCP套接字的话，它会试图获得一个新的TCP连接。
	
	* accept() 用于服务器端。 它接受一个从远端客户端发出的创建一个新的TCP连接的接入请求，创建一个新的套接字，与该连接相应的套接字地址相关联。
	
	* send()和recv(),或者write()和read(),或者recvfrom()和sendto(), 用于往/从远程套接字发送和接受数据。
	
	* close() 用于系统释放分配给一个套接字的资源。 如果是TCP，连接会被中断。

	基本TCP客户—服务器程序设计基本框架 :
	
	![img](http://7xql77.com1.z0.glb.clouddn.com/tcp_cs.jpg)
	
	基本UDP客户—服务器程序设计基本框架流程图 :
	
	![img](http://7xql77.com1.z0.glb.clouddn.com/udp_cs.jpg)
	
	具体代码参考：[BSDSocket](https://github.com/JhonChan/Learning/tree/master/SocketDemo/BSDSocket)
	
2. 基于C的CFNetwork

	CFNetwork框架包括的类库如下：

	![img](http://7xql77.com1.z0.glb.clouddn.com/cfnetwork_framework_layer.png)

	CFNetwork 接口是基于 C 的，下面的接口用于创建一对 socket stream，一个用于读取，一个用于写入：
	
		void CFStreamCreatePairWithSocketToHost(CFAllocatorRef alloc, CFStringRef host, UInt32 port, CFReadStreamRef *readStream, CFWriteStreamRef *writeStream);
	
	该函数使用 host 以及 port，CFNetwork 会将该 host 转换为 IP 地址，并转换为网络字节顺序。如果我们只需要一个 socket stream，我们可以将另外一个设置为 NULL。还有另外两个“重载”的创建 socket sream的接口：CFStreamCreatePairWithSocket 和 CFStreamCreatePairWithPeerSocketSignature。
	注意：在使用这些 socket stream 之前，必须显式地调用其 open 函数：

		Boolean CFReadStreamOpen(CFReadStreamRef stream);
		Boolean CFWriteStreamOpen(CFWriteStreamRef stream);
	
	但与 socket 不同的是，这两个接口是异步的，当成功 open 之后，如果调用方设置了获取 kCFStreamEventOpenCompleted 事件的标志的话就会其调用回调函数。
而该回调函数及其参数设置是通过如下接口进行的：

		Boolean CFReadStreamSetClient(CFReadStreamRef stream, CFOptionFlags streamEvents, CFReadStreamClientCallBack clientCB, CFStreamClientContext *clientContext);
		Boolean CFWriteStreamSetClient(CFWriteStreamRef stream, CFOptionFlags streamEvents, CFWriteStreamClientCallBack clientCB, CFStreamClientContext *clientContext);
	
	该函数用于设置回调函数及相关参数。通过 streamEvents 标志来设置我们对哪些事件感兴趣；clientCB 是一个回调函数，当事件标志对应的事件发生时，该回调函数就会被调用；clientContext 是用于传递参数到回调函数中去。
	
	当设置好回调函数之后，我们可以将 socket stream 当做事件源调度到 run-loop 中去，这样 run-loop 就能分发该 socket stream 的网络事件了。

		void CFReadStreamScheduleWithRunLoop(CFReadStreamRef stream, CFRunLoopRef runLoop, CFStringRef runLoopMode);
		void CFWriteStreamScheduleWithRunLoop(CFWriteStreamRef stream, CFRunLoopRef runLoop, CFStringRef runLoopMode);
	
	注意，在我们不再关心该 socket stream 的网络事件时，记得要调用如下接口将 socket stream 从 run-loop 的事件源中移除。

		void CFReadStreamUnscheduleFromRunLoop(CFReadStreamRef stream, CFRunLoopRef runLoop, CFStringRef runLoopMode);
		void CFWriteStreamUnscheduleFromRunLoop(CFWriteStreamRef stream, CFRunLoopRef runLoop, CFStringRef runLoopMode);
	
	当我们将 socket stream 的网络事件调度到 run-loop 之后，我们就能在回调函数中相应各种事件，比如 kCFStreamEventHasBytesAvailable 读取数据：

		Boolean CFReadStreamHasBytesAvailable(CFReadStreamRef stream);
		CFIndex CFReadStreamRead(CFReadStreamRef stream, UInt8 *buffer, CFIndex bufferLength);
	
	或 kCFStreamEventCanAcceptBytes 写入数据：

		Boolean CFWriteStreamCanAcceptBytes(CFWriteStreamRef stream);
		CFIndex CFWriteStreamWrite(CFWriteStreamRef stream, const UInt8 *buffer, CFIndex bufferLength);
		
	最后，我们调用 close 方法关闭 socket stream：

		void CFReadStreamClose(CFReadStreamRef stream);
		void CFWriteStreamClose(CFWriteStreamRef stream);
	
	使用CFNetwork编程流程图如下：

	![img](http://7xql77.com1.z0.glb.clouddn.com/cfnetwork_layer.png)

	具体代码参考：[CFSocket](https://github.com/JhonChan/Learning/tree/master/SocketDemo/CFSocket)
	
3. NSStream

	NSStream 其实只是用 Objective-C 对 CFNetwork 的简单封装，它使用名为 NSStreamDelegate 的协议来实现 CFNetwork 中的回调函数的作用，同样，runloop 也与 NSStream 结合的很好。NSStream 有两个实体类：NSInputStream 和 NSOutputStream，分别对应 CFNetwork 中的 CFReadStream 和 CFWriteStream。
	
	NSStream 类有如下接口：

	* -(void)open;//打开流
	
	* -(void)close;//关闭流 
	
	* -(void)setDelegate:(id <NSStreamDelegate>)delegate;//代理
	
	* -(void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;//添加到runloop的特定模式
	
	* -(void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
	//从runloop的特定模式删除
	
	* -(NSStreamStatus)streamStatus;//流状态
	
	* -(NSError *)streamError;

	 NSStream 是通过 NSStreamDelegate 来实现 CFNetwork 中的回调函数，这个可选的协议只有一个接口：

	- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;

	NSStreamEvent 是一个流事件枚举：

		typedef NS_OPTIONS(NSUInteger, NSStreamEvent) {
		    NSStreamEventNone = 0,//无
		    NSStreamEventOpenCompleted = 1UL << 0,//流打开完毕
		    NSStreamEventHasBytesAvailable = 1UL << 1,//可以读取数据
		    NSStreamEventHasSpaceAvailable = 1UL << 2,//可以发送数据
		    NSStreamEventErrorOccurred = 1UL << 3,//发生错误
		    NSStreamEventEndEncountered = 1UL << 4//数据接收完毕
		};

	NSInputStream 类有如下接口：
	
	* -(NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;
	从流中读取数据到 buffer 中，buffer 的长度不应少于 len，该接口返回实际读取的数据长度（该长度最大为 len）。
	
	* -(BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len;
	获取当前流中的数据以及大小，注意 buffer 只在下一个流操作之前有效。
	
	* -(BOOL)hasBytesAvailable;
	检查流中是否还有数据。

	NSOutputStream 类有如下接口：
	
	* -(NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len;
	将 buffer 中的数据写入流中，返回实际写入的字节数。
	
	* -(BOOL)hasSpaceAvailable;
	检查流中是否还有可供写入的空间。
	
	使用NSStream编程流程图：
	
	![img](http://7xql77.com1.z0.glb.clouddn.com/nsstream_layer.png)

	具体代码参考：[NSStream](https://github.com/JhonChan/Learning/tree/master/SocketDemo/NSStream)

### 第三方库CocoaAsyncSocket

使用NSStream显然已经很方便了，第三方库cocoaasyncsocket使iOS的socket实现更加简单。
cocoaasyncsocket是支持tcp和udp的，利用它可以轻松实现建立连接、断开连接、发送socket业务请求、重连这四个基本功能。下面简单描述一下步骤。

1. 获取GCDAsyncSocket对象。在GCDAsyncSocket中提供了四种初始化的方法
	
	- (id)init;
	
	- (id)initWithSocketQueue:(dispatch_queue_t)sq;
	
	- (id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;
	
	- (id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq socketQueue:(dispatch_queue_t)sq;
	
	
	sq是socket的线程，这个是可选的设置，如果你写null，GCDAsyncSocket内部会帮你创建一个它自己的socket线程，如果你要自己提供一个socket线程的话，千万不要提供一个并发线程，在频繁socket通信过程中，可能会阻塞掉。
	
	aDelegate就是socket的代理
	
	dq是delegate的线程
	
	注意：必须设置socket的代理以及代理的线程，否则socket的回调无法调起。

2. 建立跟服务器的连接。

	- (BOOL)connectToHost:(NSString*)host onPort:(uint16_t)port error:(NSError**)errPtr;

		host是主机地址，port是端口号。如果建连成功之后，会收到socket成功的回调，在成功里面你可以做你需要做的一些事情，比如心跳的处理：

			- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port
	
		如果建连失败了，会收到失败的回调，这里可以做重连的操作：

			- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err

3. 发送数据

	在拼装好socket请求数据(格式、分界符要与后台商定)之后，你需要调用GCDAsyncSocket的写方法，来发送请求，然后在写完成之后你会收到写的回调

		[self.socket writeData:requestData withTimeout:-1 tag:0];
	
	timeout是超时时间，这个根据实际的需要去设置

	这个是写的回调

		- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag；
	
	在写之后，需要再调用读方法，这样才能收到你发出请求后从服务器那边收到的数据

		[self.socketreadDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:50000 tag:0];
		
	[GCDAsyncSocket CRLFData]这里是设置边界符，maxLength是设置你收到的请求数据内容的最大值

	在读回调里面，你可以根据不同业务来执行不同的操作

		- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag；
		
	最后一个则是断开连接，这个只需要调用

		[self.socket disconnect];
		
	ok，这样的话，最简单基础的socket通信，你已经大致能完成了~
	
	具体代码参考： [GCDAsyncSocketDemo](https://github.com/JhonChan/Learning/tree/master/SocketDemo/GCDAsyncSocketDemo)

	更多使用方法见[https://github.com/robbiehanson/CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket).