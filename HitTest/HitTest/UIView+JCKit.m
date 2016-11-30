//
//  UIView+JCKit.m
//  HitTest
//
//  Created by CXY on 16/11/17.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "UIView+JCKit.h"
#import <objc/runtime.h>

static NSString *const kJCHitTestBlockKey = @"setHitTestBlock:";
static NSString *const kJCPointInsideBlockKey = @"setPointInsideBlock:";

@implementation UIView (JCKit)


/**
 替换方法输出多余信息
 */
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(hitTest:withEvent:)), class_getInstanceMethod(self, @selector(jc_hitTest:withEvent:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(pointInside:withEvent:)), class_getInstanceMethod(self, @selector(jc_pointInside:withEvent:)));
}

- (UIView *)jc_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSMutableString *space = [NSMutableString string];
    UIView *superView = self.superview;
    while (superView) {
        [space appendString:@"----"];
        superView = superView.superview;
    }
    NSLog(@"%@%@:[hitTest:withEvent:]", space, NSStringFromClass(self.class));
    UIView *hitTestView = nil;
    if (self.hitTestBlock) {
        BOOL returnSuper = NO;
        hitTestView = self.hitTestBlock(point, event, &returnSuper);
        if (returnSuper) {
            hitTestView = [self jc_hitTest:point withEvent:event];
        }
    } else {
        hitTestView = [self jc_hitTest:point withEvent:event];
    }
    return hitTestView;
}

- (BOOL)jc_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSMutableString *space = [NSMutableString string];
    UIView *superView = self.superview;
    while (superView) {
        [space appendString:@"----"];
        superView = superView.superview;
    }
    NSLog(@"%@%@:[pointInside:withEvent:]", space, NSStringFromClass(self.class));
    BOOL pointInside = NO;
    if (self.pointInsideBlock) {
        BOOL returnSuper = NO;
        pointInside  = self.pointInsideBlock(point, event, &returnSuper);
        if (returnSuper) {
            pointInside = [self jc_pointInside:point withEvent:event];
        }
    } else  {
        pointInside = [self jc_pointInside:point withEvent:event];
    }
    return pointInside;
}

#pragma mark Setter & Getter
- (void)setHitTestBlock:(JCHitTestBlock)hitTestBlock {
    objc_setAssociatedObject(self, _cmd, hitTestBlock, OBJC_ASSOCIATION_COPY);
}

- (JCHitTestBlock)hitTestBlock {
    return objc_getAssociatedObject(self, (__bridge const void *)(kJCHitTestBlockKey));
}

- (void)setPointInsideBlock:(JCPointInsideBlock)pointInsideBlock {
    objc_setAssociatedObject(self, _cmd, pointInsideBlock, OBJC_ASSOCIATION_COPY);
}

- (JCPointInsideBlock)pointInsideBlock {
    return objc_getAssociatedObject(self, (__bridge const void *)(kJCPointInsideBlockKey));
}


@end
