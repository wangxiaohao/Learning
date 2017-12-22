//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport



class MyViewController : UIViewController {
    
    var img: UIImageView?
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let btn = UIButton(type: .custom)
        btn.setTitle("loadImg", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        btn.frame = CGRect(x: 150, y: 200, width: 100, height: 20)
        view.addSubview(btn)
        
        let img = UIImageView()
        img.frame = CGRect(x: 150, y: 250, width: 100, height: 100)
        view.addSubview(img)
        self.img = img

        self.view = view
    }
    
    @objc func loadImage() {
        Networking().requestImage { (data) in
            DispatchQueue.main.async {
                if let ig = UIImage(data: data) {
                    self.img?.image = ig
//                    PlaygroundPage.current.needsIndefiniteExecution = false
                }
            }
        }

    }
    
    override func viewDidLoad() {
        
    }
}
// Present the view controller in the Live View window
//PlaygroundPage.current.needsIndefiniteExecution = true
let vc = MyViewController()
PlaygroundPage.current.liveView = vc






