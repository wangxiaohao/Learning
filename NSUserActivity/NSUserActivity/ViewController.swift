//
//  ViewController.swift
//  NSUserActivity
//
//  Created by CXY on 2017/7/19.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func restoreUserActivity(_ userActivity: NSUserActivity) {
        guard let title = userActivity.title else { return }
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: title)
        navigationController?.pushViewController(vc, animated: true)
    }

}

