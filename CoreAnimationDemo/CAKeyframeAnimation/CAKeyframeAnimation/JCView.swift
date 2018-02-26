//
//  JCView.swift
//  CAKeyframeAnimation
//
//  Created by CXY on 17/3/9.
//  Copyright © 2017年 CXY. All rights reserved.
//

import Foundation
import UIKit

class JCView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.draw((UIImage(named:"")?.cgImage)!, in: self.bounds)
        
    }
}
