//
//  ViewController.swift
//  CABasicAnimation
//
//  Created by CXY on 17/2/28.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ani = CABasicAnimation()
        ani.keyPath = "transform.scale"
        ani.fromValue = NSNumber(value: 0)
        ani.repeatCount = MAXFLOAT
        ani.duration = 0.5
        ani.autoreverses = true
        self.imageView.layer .add(ani, forKey: "shakeHeartAnimation")
        
        ani.keyPath = "position"
        ani.fromValue = NSValue(cgPoint: CGPoint(x: 100, y:100))
    }


}

