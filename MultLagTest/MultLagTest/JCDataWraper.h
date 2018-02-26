//
//  JCDataWraper.h
//  MultLagTest
//
//  Created by CXY on 2018/2/6.
//  Copyright © 2018年 ubtechinc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCDataWraper : NSObject
@property (nonatomic, copy) NSString *string;
- (instancetype)initWithString:(NSString *)str;
@end
