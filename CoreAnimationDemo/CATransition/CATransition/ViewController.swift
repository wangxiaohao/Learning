//
//  ViewController.swift
//  CATransition
//
//  Created by CXY on 17/2/28.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var index = 1
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
        
        UIView.transition(with: self.imageView, duration: 0.5, options: [.transitionCurlUp], animations: {
            self.index += 1
            if self.index == 4 {
                self.index = 1
            }
            self.imageView.image = UIImage(named: String(self.index))
        }) { (finished) in
            
        }
    }
    
    func flipPage() {
        index += 1
        if index == 4 {
            index = 1
        }
        let transitionAni = CATransition()
        transitionAni.startProgress = 0
        transitionAni.endProgress = 1
        transitionAni.type = "pageCurl"
        self.imageView.layer.add(transitionAni, forKey: "")
        self.imageView.image = UIImage(named: String(index))
    }
}

