//
//  JCView.swift
//  CoreTextSwift
//
//  Created by CXY on 17/2/22.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit
import Foundation

class JCView: UIView {
    var image: UIImage?
    var ctFrame: CTFrame?
    var imageFrames: [CGRect] = [CGRect]()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 1 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // 2 转换坐标：uikit坐上原点，CoreText&CoreGrapic已左下为原点
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: self.bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        // 3 绘制区域
        let path = UIBezierPath(rect: rect)
        // 4 创建需要绘制的文字
        let attrString = "Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreTextCoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!end"
        
        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        mutableAttrStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                                      NSForegroundColorAttributeName: UIColor.red], range: NSMakeRange(0, 5))
        mutableAttrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13),NSUnderlineStyleAttributeName: 1], range: NSMakeRange(3,10))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6 //行间距
        mutableAttrStr.addAttributes([NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(6, mutableAttrStr.length-6))
        // 5 为图片设置CTRunDelegate,delegate决定留给图片的空间大小
        var imageName = "xiaoyang.jpg"
        var imageCallback =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
            
        }, getAscent: { ( refCon) -> CGFloat in
            
            //                let imageName = "mc"
            //                refCon.initialize()
            //                let image = UIImage(named: imageName)
            return 100  //返回高度
        }, getDescent: { (refCon) -> CGFloat in
            return 50  //返回底部距离
        }, getWidth: { (refCon) -> CGFloat in
            
            //                let imageName = String("mc")
            //                let image = UIImage(named: imageName)
            return 100  //返回宽度
        })
        
        let runDelegate = CTRunDelegateCreate(&imageCallback, &imageName)
        let imgString = NSMutableAttributedString(string: " ") // 空格用于给图片留位置
        imgString.addAttributes([kCTRunDelegateAttributeName as String: runDelegate!], range: NSMakeRange(0, 1))
        imgString.addAttribute("imageName", value: imageName, range: NSMakeRange(0, 1))//添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgString, at: 15)
        
        //网络图片相关
        var  imageCallback1 =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
            
        }, getAscent: { ( refCon) -> CGFloat in
            return 70  //返回高度
            
        }, getDescent: { (refCon) -> CGFloat in
            
            return 50  //返回底部距离
            
        }, getWidth: { (refCon) -> CGFloat in
            return 100  //返回宽度
        })
        var imageUrl = "https://www.baidu.com/img/bd_logo1.png" //网络图片链接
        let urlRunDelegate  = CTRunDelegateCreate(&imageCallback1, &imageUrl)
        let imgUrlString = NSMutableAttributedString(string: " ")  // 空格用于给图片留位置
        imgUrlString.addAttribute(kCTRunDelegateAttributeName as String, value: urlRunDelegate!, range: NSMakeRange(0, 1))  //rundelegate  占一个位置
        imgUrlString.addAttribute("urlImageName", value: imageUrl, range: NSMakeRange(0, 1))//添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgUrlString, at: 150)
        
        
        // 6 生成framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path.cgPath, nil)
        self.ctFrame = frame
        // 7 绘制除图片以外的部分
        CTFrameDraw(frame,context)
        
        // 8 处理绘制图片逻辑
        let lines = CTFrameGetLines(frame) as NSArray //存取frame中的ctlines

        let ctLinesArray = lines as Array
        var originsArray = [CGPoint](repeating: CGPoint.zero, count:ctLinesArray.count)
        let range: CFRange = CFRangeMake(0, 0)
        CTFrameGetLineOrigins(frame, range, &originsArray)
        
        //遍历CTRun找出图片所在的CTRun并进行绘制,每一行可能有多个
        for i in 0..<lines.count {
            //遍历每一行CTLine
            let line = lines[i]
            var lineAscent = CGFloat()
            var lineDescent = CGFloat()
            var lineLeading = CGFloat()
            //该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
            CTLineGetTypographicBounds(line as! CTLine, &lineAscent, &lineDescent, &lineLeading)
            
            let runs = CTLineGetGlyphRuns(line as! CTLine) as NSArray
            for j in 0..<runs.count {
                // 遍历每一个CTRun
                var runAscent = CGFloat()
                var runDescent = CGFloat()
                let lineOrigin = originsArray[i]// 获取该行的初始坐标
                let run = runs[j] // 获取当前的CTRun
                let attributes = CTRunGetAttributes(run as! CTRun) as NSDictionary
                //CTRun的宽度
                let width =  CGFloat(CTRunGetTypographicBounds(run as! CTRun, CFRangeMake(0,0), &runAscent, &runDescent, nil))
                let runRect = CGRect(x: lineOrigin.x + CTLineGetOffsetForStringIndex(line as! CTLine, CTRunGetStringRange(run as! CTRun).location, nil), y: lineOrigin.y - runDescent, width: width, height: runAscent + runDescent)
                let imageNames = attributes["imageName"]
                let urlImageName = attributes["urlImageName"]
                
                if let imageName = imageNames as? String {
                    //本地图片
                    let image = UIImage(named: imageName)
                    let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y-runDescent, width: 100, height: 100)
                    self.imageFrames.append(imageDrawRect)
                    if let cgimage = image?.cgImage {
                        context.draw(cgimage, in: imageDrawRect)
                    }
                }
                
                if let urlImageName = urlImageName as? String {
                    var image: UIImage?
                    let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y-runDescent, width: 100, height: 100)
                    self.imageFrames.append(imageDrawRect)
                    if self.image == nil {
                        image = UIImage(named:"hs") //灰色图片占位
                        //去下载
                        if let url = NSURL(string: urlImageName){
                            let request = NSURLRequest(url: url as URL)
                            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, resp, err) -> Void in
                                if let data = data{
                                    DispatchQueue.main.sync(execute: { () -> Void in
                                        self.image = UIImage(data: data)
                                        self.setNeedsDisplay()  //下载完成会重绘
                                    })
                                }
                            }).resume()
                        }
                    } else {
                        image = self.image
                    }
                    if let CGImage = image?.cgImage {
                        context.draw(CGImage, in: imageDrawRect)
                    }
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取UITouch对象
        let touch = touches.first!
        //获取触摸点击当前view的坐标位置
        var location = touch.location(in: self)
        print("----->touch point:(x: \(location.x), y: \(location.y))")
        guard let frame = self.ctFrame else {
            return
        }
        //获取每一行
        let ctLines = CTFrameGetLines(frame) as! [CTLine]
        let count = ctLines.count
        var origins = [CGPoint](repeating: CGPoint.zero, count:count)
        //获取每行的原点坐标
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        var line: CTLine?
        var lineOrigin = CGPoint.zero
        for i in 0..<count {
            let origin = origins[i];
            let path = CTFrameGetPath(frame)
            //获取整个CTFrame的大小
            let rect = path.boundingBox
            print("---->整个CTFrame的大小\(rect)")
            //坐标转换，把每行的原点坐标转换为uiview的坐标体系
            let y = rect.origin.y + rect.size.height - origin.y
            //判断点击的位置处于那一行范围内
            if ((location.y <= y) && (location.x >= origin.x)) {
                line = ctLines[i]
                lineOrigin = origin;
                print("---->当前行\(i+1)")
                break;
            }
        }
        
        location.x -= lineOrigin.x;
        //获取点击位置所处的字符位置，就是相当于点击了第几个字符
        var index = 0
        if let line = line {
           index = CTLineGetStringIndexForPosition(line, location) as Int
        }
        //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
        if index>=1 && index<=10 {
            let alertView = UIAlertController(title: "点击", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            if let tmp = self.next?.next, let next = tmp as? ViewController {
                next.present(alertView, animated: true, completion: nil)
            }
        }
    }
}
