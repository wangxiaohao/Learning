//
//  ViewController.swift
//  Quartz2D
//
//  Created by CXY on 17/2/28.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let view = MyView(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
////        view.backgroundColor = UIColor.white
//        self.view.addSubview(view)
        
        let view = SnowView(frame: self.view.bounds)
        //        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

