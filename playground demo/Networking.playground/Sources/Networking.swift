import Foundation

public class Networking: NSObject {
    private let picPath = "https://www.baidu.com/img/bd_logo1.png"
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.timeoutIntervalForRequest = 10
        let ses = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        return ses
    }()
    
    public func requestImage(_ success: ((Data) -> Void)? = nil) {
        if let url = URL(string: self.picPath) {
            session.dataTask(with: url) { (data, res, err) in
                if let dat = data {
                    success?(dat)
                }
                }.resume()
        }
    }
}
