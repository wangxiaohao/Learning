//
//  JCButton.m
//  HitTest
//
//  Created by CXY on 16/11/17.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "JCButton.h"

@implementation JCButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect touchRect = CGRectInset(self.bounds, -10, -10);
    return CGRectContainsPoint(touchRect, point);
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
