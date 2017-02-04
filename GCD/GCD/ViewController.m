//
//  ViewController.m
//  GCD
//
//  Created by CXY on 16/11/9.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1
//    [self dispatch_apply];
    //2
//    [self dispatch_group];
    //3
//    [self dispatch_barrier_async];
    //4
    [self dispatch_semaphore];
    
}


/**
 dispatch_apply重复执行n次，同步等待执行后面的任务。
 */
- (void)dispatch_apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"%zu", index);
    });
    NSLog(@"任务完成");
//    输出结果：全局并行队列并行执行，输出顺序不定
//    2016-11-22 17:42:45.750 GCD[4501:305970] 1
//    2016-11-22 17:42:45.750 GCD[4501:305765] 0
//    2016-11-22 17:42:45.750 GCD[4501:305975] 2
//    2016-11-22 17:42:45.750 GCD[4501:305971] 3
//    2016-11-22 17:42:45.750 GCD[4501:305970] 4
//    2016-11-22 17:42:45.750 GCD[4501:305765] 5
//    2016-11-22 17:42:45.750 GCD[4501:305975] 6
//    2016-11-22 17:42:45.751 GCD[4501:305971] 7
//    2016-11-22 17:42:45.751 GCD[4501:305970] 8
//    2016-11-22 17:42:45.751 GCD[4501:305765] 9
//    2016-11-22 17:42:45.751 GCD[4501:305765] 任务完成
}


/**
 下载图片1和2，下载完成后合成为新图片
 */
- (void)dispatch_group {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    __block UIImage *image1 = nil;
    dispatch_group_async(group, queue, ^{
        NSURL * url = [NSURL URLWithString:@"http://img.knowledge.csdn.net/upload/base/1452496101906_906.jpg"];
        NSData * data = [[NSData alloc] initWithContentsOfURL:url];
        image1 = [[UIImage alloc] initWithData:data];
    });
    
    __block UIImage *image2 = nil;
    dispatch_group_async(group, queue, ^{
        NSURL * url = [NSURL URLWithString:@"http://img.knowledge.csdn.net/upload/base/1454051093684_684.jpg"];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        image2 = [[UIImage alloc]initWithData:data];
    });
    
    dispatch_group_notify(group, queue, ^{
        UIImage *ret = [self groupImage:image1 otherImage:image2];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = ret;
        });
    });

}


/**
 合成图片

 @param img1 输入图片
 @param img2 输入图片
 @return 合成的图片
 */
- (UIImage *)groupImage:(UIImage *)img1 otherImage:(UIImage *)img2 {
    UIGraphicsBeginImageContext(CGSizeMake(img1.size.width+img2.size.width, MAX(img2.size.height, img1.size.height)));
    [img1 drawInRect:CGRectMake(0, 0, img1.size.width, img1.size.height)];
    [img2 drawInRect:CGRectMake(img1.size.width, 0, img2.size.width, img2.size.height)];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}


/**
 异步中添加同步点：可用于读写同步，见JCCache
 */
- (void)dispatch_barrier_async {
    dispatch_queue_t queue = dispatch_queue_create("com.cxy.gcdtest", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async2");
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_barrier_async");
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async4");
    });
    //由于并行队列，执行顺序不定
//    2016-11-25 11:45:47.571 GCD[2283:103879] dispatch_async2
//    2016-11-25 11:45:47.571 GCD[2283:103877] dispatch_async1
//    2016-11-25 11:45:51.575 GCD[2283:103877] dispatch_barrier_async
//    2016-11-25 11:45:52.580 GCD[2283:103877] dispatch_async3
//    2016-11-25 11:45:52.580 GCD[2283:103879] dispatch_async4
}


- (void)dispatch_semaphore {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSMutableArray *arr = [NSMutableArray array];
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_apply(10000, queue, ^(size_t index) {
        NSLog(@"%zu", index);
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [arr addObject:[NSNumber numberWithInt:(int)index]];
//        dispatch_semaphore_signal(semaphore);
    });

    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    
    for (NSInteger i = 0; i < 10000; i ++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            //your code here
            [arr addObject:[NSNumber numberWithInteger:i]];
            dispatch_semaphore_signal(sem);
        });
    }
}

@end
