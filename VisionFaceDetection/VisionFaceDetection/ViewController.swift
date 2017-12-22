//
//  ViewController.swift
//  VisionFaceDetection
//
//  Created by CXY on 2017/12/19.
//  Copyright © 2017年 ubtechinc. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var highlightView: UIView? {
        didSet {
            self.highlightView?.layer.borderColor = UIColor.red.cgColor
            self.highlightView?.layer.borderWidth = 4
            self.highlightView?.backgroundColor = .clear
            self.highlightView?.frame = CGRect(x: 100, y: 100, width: 120, height: 120)
        }
    }
    
//    fileprivate lazy var cameraLayer: CALayer = {
//        let previewLayer = CALayer()
//        previewLayer.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: self.view.frame.size.width)
//        previewLayer.position = CGPoint(x:self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0);
//        previewLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0)));
//        return previewLayer
//    }()
    
    fileprivate lazy var cameraLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    fileprivate lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.high
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front), let input = try? AVCaptureDeviceInput(device: backCamera) else {
            return session
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // register to receive buffers from the camera
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            guard let captureConnection = videoOutput.connection(with: AVMediaType.video) else { return session }
            if captureConnection.isVideoOrientationSupported {
                captureConnection.videoOrientation = .portrait
            }
            // 视频稳定设置
//            if captureConnection.isVideoStabilizationSupported {
//                captureConnection.preferredVideoStabilizationMode = .auto
//            }
        }
        return session
    }()
    
    fileprivate lazy var faceDetectionRequestHandler: VNSequenceRequestHandler = {
        let handler = VNSequenceRequestHandler()
        return handler
    }()
    
    fileprivate lazy var faceDetectionRequest: VNDetectFaceRectanglesRequest = {
        let req = VNDetectFaceRectanglesRequest(completionHandler: handleRectangleRequestUpdate)
        return req
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(cameraLayer)
        cameraLayer.frame = view.bounds
        self.view.bringSubview(toFront: self.highlightView!)
        captureSession.startRunning()
    }

    
    fileprivate func handleRectangleRequestUpdate(_ request: VNRequest, error: Error?) {
        // Dispatch to the main queue because we are touching non-atomic, non-thread safe properties of the view controller
        DispatchQueue.main.async {
            // make sure we have an actual result
            guard let newObservation = request.results?.first as? VNFaceObservation else {
                print("no face")
                return
            }
        
            // calculate view rect
            let transformedRect = newObservation.boundingBox
            //            transformedRect.origin.y = 1 - transformedRect.origin.y
            let convertedRect = self.cameraLayer.layerRectConverted(fromMetadataOutputRect: transformedRect)
            
            // move the highlight view
            self.highlightView?.frame = convertedRect
        }
    }
}


extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let request = VNTrackRectangleRequest()
        do {
//            var requestOptions:[VNImageOption : Any] = [:]
//
//            if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
//                requestOptions = [.cameraIntrinsics:camData]
//            }
//            let reqHandelr = VNImageRequestHandler(cvPixelBuffer: pixBuffer, orientation: .up, options: requestOptions)
////            let faceReq = VNDetectFaceRectanglesRequest(completionHandler: handleRectangleRequestUpdate)
//            try reqHandelr.perform([faceReq])
            try faceDetectionRequestHandler.perform([faceDetectionRequest], on: pixBuffer)
        } catch  {
            print("Throws: \(error)")
        }
        
        
    }
}


