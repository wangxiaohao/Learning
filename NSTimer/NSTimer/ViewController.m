//
//  ViewController.m
//  NSTimer
//
//  Created by CXY on 16/6/13.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    
}
@property (strong, nonatomic) NSThread *timerThread;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //问题：当用户滑动显示屏，则会出现Timer失效，方法不调用的情况（因为一般Timer是运行在RunLoop的default mode上，而ScrollView在用户滑动时，主线程RunLoop会转到UITrackingRunLoopMode。而这个时候，Timer就不会运行,方法得不到fire。）
    //第一种解决方法:修改RunLoop 运行模式为 NSRunLoopCommonModes
//    _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(update:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    //第二种解决方法:在子线程中启动timer，添加timer到runloop,注意：子线程中RunLoop需要手动配置开启
    NSThread *thread  = [[NSThread alloc] initWithTarget:self selector:@selector(threadEntry) object:nil];
    thread.name = @"TimerThread";
    [thread start];
    _timerThread = thread;
}

- (void)update:(NSTimer *)timer
{
    NSLog(@"%@----->fire at %@", timer.description, timer.fireDate);
    //do update ui
}

- (void)threadEntry
{
    _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    //子线程RunLoop手动配置开启
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    [runLoop run];
}

- (void)cancel
{
    //NSTimer要在同一个线程中创建和关闭。因为创建的Timer的时候已经把Timer加入到该线程对应的RunLoop中，这个RunLoop设置了这个Timer为一个事件。因此要在同一个线程中才能cancel这个Timer。
    [self performSelector:@selector(invalidTimer) onThread:_timerThread withObject:nil waitUntilDone:YES];
}

- (void)invalidTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

//NSTimer的一些坑
/*1.没有scheduled方式初始化的，需要我们手动调用addTimer:forMode:方法，将timer添加到一个runloop中.
 举例：
 
 NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0
 target:self
 selector:@selector(timerFired:)
 userInfo:nil
 repeats:NO];
 //need add to runloop
 NSTimer *timer2 = [NSTimer timerWithTimeInterval:3.0
 target:self
 selector:@selector(timerFired:)
 userInfo:nil
 repeats:NO];
 [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
 2.scheduled方式创建的timer不会立即执行，需要调用fire函数或者手动调用一次目标方法。
 
 3.timer并不是一种实时机制，会存在延迟，而且延迟的程度跟当前线程的执行情况有关。通常会有50ms-100ms的延迟。
 
 NSTimer不是一个实时系统，因此不管是一次性的还是周期性的timer的实际触发事件的时间可能都会跟我们预想的会有出入。差距的大小跟当前我们程序的执行情况有关系，比如可能程序是多线程的，而你的timer只是添加在某一个线程的runloop的某一种指定的runloopmode中，由于多线程通常都是分时执行的，而且每次执行的mode也可能随着实际情况发生变化。
 
 4.NSTimer都会对它的target进行retain，我们需要小心对待这个target的生命周期问题。
 发现的原因是在webView中调用一段JS代码，发现JS代码只有在应用启动后运行一次，退出webView后再次进入就JS代码就不会执行了，折腾了一晚上一直没找到原因。后来监控webView的内存地址发现退出后webView没有释放，内存泄露了。原来的代码如下：
 
 self.detectTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
 target:self
 selector:@selector(someMethod)
 userInfo:nil
 repeats:YES];
 - (void)dealloc {
 ...
 [self.detectTimer invalidate];
 self.detectTimer = nil;
 ...}
 由于timer对target:self的retain，造成self退出后根本没有调用dealloc，以至于viewController不会被释放导致内存泄露。后来修改了代码，把计时器的释放操作放到viewWillDisappear中来管理问题就解决了。看来ARC的时代也还是不能忽视内存问题啊。
 
*/



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
