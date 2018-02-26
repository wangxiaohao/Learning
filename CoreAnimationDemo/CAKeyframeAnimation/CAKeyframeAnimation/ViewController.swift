//
//  ViewController.swift
//  CAKeyframeAnimation
//
//  Created by CXY on 17/2/28.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

extension Double {
    var angle2Radian: Double {
        return (self/180.0*M_PI)
    }
}


class ViewController: UIViewController {

    @IBOutlet var ges: UILongPressGestureRecognizer!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageView.addGestureRecognizer(ges)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        let keyFrameAni = CAKeyframeAnimation()
        keyFrameAni.keyPath = "transform.rotation"
        keyFrameAni.values = [-5.0.angle2Radian, 5.0.angle2Radian]
        keyFrameAni.autoreverses = true
        keyFrameAni.repeatCount = MAXFLOAT
        keyFrameAni.duration = 0.5
        self.imageView.layer.add(keyFrameAni, forKey: "DeleteAppShake")
    }
    

}

