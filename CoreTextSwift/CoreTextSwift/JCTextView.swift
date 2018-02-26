//
//  JCTextView.swift
//  CoreTextSwift
//
//  Created by CXY on 17/2/24.
//  Copyright © 2017年 CXY. All rights reserved.
//

import Foundation
import UIKit

class JCTextView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1 获取上下文
        guard let context = UIGraphicsGetCurrentContext()  else {
            return
        }
        // 2 转换坐标：uikit坐上原点，CoreText&CoreGrapic已左下为原点
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: self.bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        // 3 绘制区域
        let path = CGMutablePath()
        path.addEllipse(in: self.bounds)
        // 4 创建需要绘制的文字
        let attrString = "Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!///end"
        
        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        mutableAttrStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                                      NSForegroundColorAttributeName: UIColor.red], range: NSMakeRange(0, 5))
        mutableAttrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13),NSUnderlineStyleAttributeName: 1], range: NSMakeRange(3,10))
        
        // 5 生成framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path, nil)
        // 6 绘制文本
        CTFrameDraw(frame,context)
    }
}
