//
//  ViewController.swift
//  CoreTextSwift
//
//  Created by CXY on 17/2/22.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit
import QuartzCore

let ScreenWidth = UIScreen.main.bounds.size.width

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = JCView(frame: CGRect(x: 0, y: 100, width: ScreenWidth, height: ScreenWidth))
//        view.image = UIImage(named: "https://www.baidu.com/img/bd_logo1.png")
        view.backgroundColor = .black
        self.view.addSubview(view)
//        let view = JCTextView(frame: CGRect(x: 0, y: 100, width: 300, height: 300))
//        view.backgroundColor = UIColor.white
//        self.view.addSubview(view)
//        let blueLayer = CALayer()
//        blueLayer.backgroundColor = UIColor.blue.cgColor
//        blueLayer.frame = CGRect(x: 0, y: 100, width: 400, height: 400)
//        self.view.layer.addSublayer(blueLayer)
//        
//        let redLayer = CALayer()
//        redLayer.backgroundColor = UIColor.red.cgColor
//        redLayer.position = CGPoint(x: 100, y: 100)
//        redLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
//        redLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
//        blueLayer.addSublayer(redLayer)
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}

