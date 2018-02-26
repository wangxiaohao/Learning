//
//  Item3ViewController.swift
//  NSUserActivity
//
//  Created by CXY on 2017/7/24.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

class Item3ViewController: UIViewController {

    var activity: NSUserActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivity()
    }
    
    func addActivity() {
        activity = NSUserActivity(activityType: "haha")
        activity?.title = "item3"
        activity?.keywords = ["it"]
        activity?.isEligibleForSearch = true
        activity?.isEligibleForHandoff = false
        // 每个控制器的user activity和 搜索结果都是仅当应用曾经被打开过时而创建的
        // activity.eligibleForPublicIndexing = true
        activity?.becomeCurrent()
    }

}
