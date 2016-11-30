//
//  UIView+JCKit.h
//  HitTest
//
//  Created by CXY on 16/11/17.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 切记，千万不要在这个block中调用self hitTest:withPoint,否则则会造成递归调用。这个方法就是hitTest:withEvent的一个代替。

 @param point       参考UIView hitTest:withEvent:
 @param event       参考UIView hitTest:withEvent:
 @param returnSuper 是否返回Super的值。如果*returnSuper=YES,则代表会返回 super hitTest:withEvent:, 否则则按照block的返回值(即使是nil)

 @return Hit-Test View
 */
typedef UIView *(^JCHitTestBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);
typedef BOOL(^JCPointInsideBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);


/**
 这个category的目的就是方便的编写hitTest方法，由于hitTest方法是override，而不是delegate，所以使用默认的实现方式就比较麻烦
 */
@interface UIView (JCKit)

@property (nonatomic, copy) JCHitTestBlock hitTestBlock;
@property (nonatomic, copy) JCPointInsideBlock pointInsideBlock;
@end
