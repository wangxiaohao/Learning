//
//  SnowView.swift
//  Quartz2D
//
//  Created by CXY on 17/2/28.
//  Copyright © 2017年 CXY. All rights reserved.
//

import Foundation
import UIKit


let ScreenWidth = UIScreen.main.bounds.size.width


class SnowView: UIView {
    var displayLink: CADisplayLink?
    var snowY: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        displayLink = CADisplayLink(target: self, selector: #selector(SnowView.updateView))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func updateView() {
        snowY += 10
        if snowY > self.bounds.size.height {
            snowY = 0
        }
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        guard let ctx = UIGraphicsGetCurrentContext() else {
//            return
//        }
//        ctx.saveGState()
        let image = UIImage(named: "snow")
        image?.draw(at: CGPoint(x: 10, y: snowY))
        print("y==\(snowY)")
        
//        ctx.restoreGState()
    }
}
