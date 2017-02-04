//
//  main.m
//  OCChainProgramming
//
//  Created by CXY on 16/12/15.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //OC链式编程
        Person *person = [Person new];
        person.name(@"Jack").address(@"USA");
        NSLog(@"person = %@", person);
    }
    return 0;
}
