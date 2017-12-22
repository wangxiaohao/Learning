//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"


var i = 4
for j in 0...5 {
    i = j + i
}

let color = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)

let image = #imageLiteral(resourceName: "DanGao_01.png")

let file = #fileLiteral(resourceName: "dd.txt")

let imageView = UIImageView()

imageView.image = image


PlaygroundPage.current.liveView = imageView


class Person {
    static let sex = "M"
    static var index: Int {
        return 10
    }
    class var overrideableComputedTypeProperty: Int {
        return 1
    }
    
    static func action() {
        print("hahahh")
    }
    
    class func hi() {
        print("hi")
    }
}

class Student: Person {
    /*
    // cannot override static var
    override static var index: Int {
        return 10
    }*/
    override class var overrideableComputedTypeProperty: Int {
        return 10
    }
    
//    override static func action() {
//        print("hahahh")
//    }
    override class func hi() {
        print("student")
    }
}

Person.action()

Person.hi()

Student.hi()
