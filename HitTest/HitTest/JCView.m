//
//  JCView.m
//  HitTest
//
//  Created by CXY on 16/11/16.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "JCView.h"

@implementation JCView

//override
/**
 hitTest:withEvent:伪代码

 @param point <#point description#>
 @param event <#event description#>

 @return <#return value description#>
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subView in [[self subviews] reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subView convertPoint:point fromView:self];
            UIView *hitTestView = [subView hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}

@end
