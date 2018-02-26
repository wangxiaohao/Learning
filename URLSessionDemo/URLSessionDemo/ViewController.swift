//
//  ViewController.swift
//  URLSessionDemo
//
//  Created by CXY on 2017/6/19.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

let Path = "http://api.openweathermap.org/data/2.5/weather?q=London,uk"

class ViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate {
    var session = URLSession()
    
    var downloadTask = URLSessionDownloadTask()
    
    lazy var resumeData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        //iOS11 later property
//        config.multipathServiceType = .aggregate
//        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 10
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
    }
    
    func dataTaskWithBlock() {
        self.session.dataTask(with: URL(string: Path)!) { (data, resp, error) in
            if let tmp = data, let str = String(data: tmp, encoding: .utf8) {
                print(str)
            }
            }.resume()
    }
    
    @IBAction func downloadTaskWithDelegate() {
        let path = "http://120.25.226.186:32812/resources/videos/minion_02.mp4"
//        let path = "http://120.25.226.186:32812/resources/images/minion_08.png"
        if let url = URL(string: path) {
            downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        }
    }
    
    // MARK: 暂停下载
    @IBAction func stopDownloadTask() {
//        downloadTask.suspend()
        downloadTask.cancel { (tmpData) in
            if let data = tmpData {
                self.resumeData = data
            }
        }
    }
    
    // MARK: 恢复下载
    @IBAction func resumeDownloadTask() {
        downloadTask = self.session.downloadTask(withResumeData: resumeData)
        downloadTask.resume()
    }
    
    @IBAction func downloadFileInBackground() {
        let config = URLSessionConfiguration.background(withIdentifier: "bgTask1")
        config.allowsCellularAccess = false
        //iOS11 later property
//        config.multipathServiceType = .aggregate
//        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 10
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let path = "http://120.25.226.186:32812/resources/videos/minion_02.mp4"
//                let path = "http://120.25.226.186:32812/resources/images/minion_08.png"
        if let url = URL(string: path) {
            downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: URLSessionDelegate
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        //get completionHandler
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.completionHandler?()
    }
    
    // MARK: 网络请求失败或主动取消时，获取已经下载的数据
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let err = error {
            print(err)
            let errorString = (err as NSError).userInfo
            
            let data = errorString["NSURLSessionDownloadTaskResumeData"]
            if let tmpData = data as? Data {
                resumeData = tmpData
            }
        }
    }
    
    // MARK: URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // 下载完成保存临时文件
        print(location)
        let fileManager = FileManager.default
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let localFileUrl = URL(fileURLWithPath: (docDir as NSString).appendingPathComponent("video.mp4"))
        do {
            try fileManager.moveItem(at: location, to: localFileUrl)
        } catch  {
            
        }
            
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print(fileOffset)
    }
}

