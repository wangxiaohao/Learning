//
//  JCCache.m
//  GCD
//
//  Created by CXY on 16/11/22.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "JCCache.h"

@interface JCCache ()
{

}

@property (strong, nonatomic) NSMutableDictionary *cache;
@property (strong, nonatomic) dispatch_queue_t queue;

@end


@implementation JCCache

static JCCache *sharedCache = nil;
+ (instancetype)sharedCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (instancetype)init {
    if (self = [super init]) {
        _cache = [NSMutableDictionary dictionary];
        _queue = dispatch_queue_create("com.jc.cachequeue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (id)cacheWithKey:(id)key {
    __block id obj = nil;
    __weak typeof(self) weakSelf = self;
    //同步读
    dispatch_sync(_queue, ^{
        obj = [weakSelf.cache objectForKey:key];
    });
    return obj;
}

- (void)setCacheObject:(id)obj withKey:(id)key {
    __weak typeof(self) weakSelf = self;
    //写同步
    dispatch_barrier_async(_queue, ^{
        [weakSelf.cache setObject:obj forKey:key];
    });
}

@end
