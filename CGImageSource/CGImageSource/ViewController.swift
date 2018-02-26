//
//  ViewController.swift
//  CGImageSource
//
//  Created by CXY on 2017/6/27.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate, URLSessionDataDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var session = URLSession()
    var recData = Data()
    var incrementallyImgSource: CGImageSource?
    
    var totalBytesExpectedToSend = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incrementallyImgSource = CGImageSourceCreateIncremental(nil)
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
//        session.downloadTask(with: URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1498568143537&di=7261f6778aa9adad47f815dec7ca04c0&imgtype=0&src=http%3A%2F%2Fd.lanrentuku.com%2Fdown%2Fpng%2F1212%2Fchristmas_icon_set_by_mkho%2Fcandles.png")!).resume()
        session.dataTask(with: URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1498568143537&di=7261f6778aa9adad47f815dec7ca04c0&imgtype=0&src=http%3A%2F%2Fd.lanrentuku.com%2Fdown%2Fpng%2F1212%2Fchristmas_icon_set_by_mkho%2Fcandles.png")!).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            let image = UIImage(data: data)
            imageView.image = image
        } catch {
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let err = error {
            print(err)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        recData.append(data)
        var isEnd = false
        if recData.count == totalBytesExpectedToSend {
            isEnd = true
        }
        CGImageSourceUpdateData(incrementallyImgSource!, recData as CFData, isEnd)
        let imageRef = CGImageSourceCreateImageAtIndex(incrementallyImgSource!, 0, nil)
        if let cgImage = imageRef {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }


}

