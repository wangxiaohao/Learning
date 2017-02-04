//
//  Person.h
//  OCChainProgramming
//
//  Created by CXY on 16/12/15.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (Person *(^)(NSString *))name;
- (Person *(^)(NSString *))address;

@end
