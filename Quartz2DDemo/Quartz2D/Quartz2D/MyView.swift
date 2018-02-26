//
//  MyView.swift
//  Quartz2D
//
//  Created by CXY on 17/2/28.
//  Copyright © 2017年 CXY. All rights reserved.
//

import Foundation
import UIKit


//- (void)drawRect:(CGRect)rect { 1.获取跟View相关联的上下 .
//    CGContextRef ctx = UIGraphicsGetCurrentContext(); 2.描述路径
//    UIBezierPath *path = [UIBezierPath bezierPath]; 设置起点
//    [path moveToPoint:CGPointMake(10, 150)]; 添加 条线到某个点
//    [path addLineToPoint:CGPointMake(290, 150)]; 将当前的上下 保存到上下 状态栈当中. CGContextSaveGState(ctx);
//    设置上下 的状态
//    CGContextSetLineWidth(ctx, 10); [[UIColor redColor] set]; 3.把路径添加到上下 当中.
//    CGContextAddPath(ctx, path.CGPath); 4.把上下 的内容渲染到View
//    CGContextStrokePath(ctx); 先把 条路径渲染到View.
//    再添加另 条路径,重新设置上下 的状态,再把路径渲染到View.
//    path = [UIBezierPath bezierPath]; 设置起点
//    [path moveToPoint:CGPointMake(150, 10)]; 添加 条线到某个点
//    [path addLineToPoint:CGPointMake(150, 290)]; 从上下 状态栈中取出 个状态. CGContextRestoreGState(ctx);
//    重新设置上下 的状态. 3.把路径添加到上下 当中. CGContextAddPath(ctx, path.CGPath);
//    4.把上下 的内容渲染到View CGContextStrokePath(ctx);


class MyView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
    
        var path = UIBezierPath()
        UIColor.blue.setStroke()
        context.setLineWidth(20)
        //        设置起点
        path.move(to: CGPoint(x: 50, y: 10))
        //        添加 条线到某个点
        path.addLine(to: CGPoint(x: 50, y: 50))
//        上下 状态栈为内存中的 块区域,它 来保存前上下 当的状态. 我们获取的图层上下 当中其实两块区域, 个是存放添加的路径, 个是 来保存 户设置 的状态,
//        这些状态包括线条的颜 ,线宽等.
        context.saveGState()
        //        设置上下 的状态
        context.setLineWidth(10)
//        context.setStrokeColor(UIColor.red.cgColor)
        UIColor.red.setStroke()
        context.addPath(path.cgPath)
        context.strokePath()
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 50))
        
        context.restoreGState()
        context.addPath(path.cgPath)
        context.strokePath()
    }
}
