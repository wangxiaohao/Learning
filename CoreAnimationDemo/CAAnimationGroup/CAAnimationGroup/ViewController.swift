//
//  ViewController.swift
//  CAAnimationGroup
//
//  Created by CXY on 17/2/28.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let translateAni = CABasicAnimation()
        translateAni.keyPath = "position"
        translateAni.toValue = CGPoint(x:400, y: 600)
        translateAni.duration = 0.5
        
        let scaleAni = CABasicAnimation()
        scaleAni.keyPath = "transform.scale"
        scaleAni.toValue = 0.1
        scaleAni.duration = 0.5
        
        let aniGroup = CAAnimationGroup()
        aniGroup.animations = [translateAni, scaleAni]
        aniGroup.fillMode = "forwards"
        aniGroup.isRemovedOnCompletion = false
        self.imageView.layer.add(aniGroup, forKey: "group")
    }


}

