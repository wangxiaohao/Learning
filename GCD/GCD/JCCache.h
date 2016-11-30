//
//  JCCache.h
//  GCD
//
//  Created by CXY on 16/11/22.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCache : NSObject

+ (instancetype)sharedCache;

- (id)cacheWithKey:(id)key;

- (void)setCacheObject:(id)obj withKey:(id)key;

@end
