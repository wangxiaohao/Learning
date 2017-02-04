//
//  Person.m
//  OCChainProgramming
//
//  Created by CXY on 16/12/15.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "Person.h"

@interface Person ()
{
    NSString *_name;
    NSString *_address;
}

@end

@implementation Person

- (Person *(^)(NSString *))name {
    return ^Person *(NSString *name){
        NSLog(@"%@--%@", NSStringFromSelector(_cmd), name);
        _name = name;
        return self;
    };
}

- (Person *(^)(NSString *))address {
    return ^Person *(NSString *address){
        NSLog(@"%@--%@", NSStringFromSelector(_cmd), address);
        _address = address;
        return self;
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{name:%@,address:%@}", _name, _address];
}

- (void)dealloc {

}
@end
