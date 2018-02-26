//
//  JCDataWraper.m
//  MultLagTest
//
//  Created by CXY on 2018/2/6.
//  Copyright © 2018年 ubtechinc. All rights reserved.
//

#import "JCDataWraper.h"

@implementation JCDataWraper
- (instancetype)initWithString:(NSString *)str {
    if (self = [super init]) {
        self.string = str;
    }
    return self;
}
@end
