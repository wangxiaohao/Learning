//
//  ViewController.swift
//  MultipleConfig
//
//  Created by CXY on 2018/2/26.
//  Copyright © 2018年 ubtechinc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = Bundle.infoForKey("Backend Url") {
            print("\(url)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension Bundle {
    static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}

