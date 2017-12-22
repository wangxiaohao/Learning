import UIKit


public class JCViewController : UIViewController {
    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hi jc!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
