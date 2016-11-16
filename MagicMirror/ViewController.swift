//
//  ViewController.swift
//  MagicMirror
//
//  Created by Reed Carson on 9/24/16.
//  Copyright © 2016 Reed Carson. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    //  @IBOutlet weak var imageView: UIImageView!
    
    // var pickerController = UIImagePickerController()
    
    var detector: CIDetector?
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    let captureSession = AVCaptureSession()
    
    let deviceCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: nil, position: .front)
    
    var camInput: AVCaptureDeviceInput {
        do {
            return try AVCaptureDeviceInput(device: deviceCamera)
        } catch {
            print("setup camInput failed")
            fatalError()
        }
        
    }
    
    var videoOutput: AVCaptureVideoDataOutput {
        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        return output
    }
    
    
    
//    func setupCaptureDevice() {
//        do {
//            return try camInput = AVCaptureDeviceInput(device: deviceCamera)
//        } catch {
//            print("setup camInput failed")
//            return
//        }
//    }
    
    func setupAVStuff() {
        
       // setupCaptureDevice()
        
//        if (camInput != nil) {
//            captureSession.addInput(camInput)
//        } else {
//            print("cam input is nil")
//            return
//        }
        
        captureSession.addInput(camInput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = self.view.frame
        
    }
    
    func configDevice() {
        do {
            try deviceCamera?.lockForConfiguration()
        } catch {
            print("configDevice lock failed")
            return
        }
        
        // deviceCamera?.foc
    }
    
    func setupDetector() {
        
        let ops: [String:Any] = [
            CIDetectorAccuracy:CIDetectorAccuracyHigh,
            CIDetectorImageOrientation:1
        ]
       
        detector = CIDetector(ofType: CIDetectorTypeFace, context: CIContext(), options: ops)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  pickerController.delegate = self
        //  pickerController.sourceType = .camera
        // imageView.image = pickerController.
        
       
        
        setupAVStuff()
        
        configDevice()
        
        self.view.layer.addSublayer(previewLayer)
        

         setupDetector()
        
        setOutput()
        
    

        
        DispatchQueue.global(qos: .background).async {
            
            if self.captureSession.canAddOutput(self.videoOutput) {
                self.captureSession.addOutput(self.videoOutput)
                print("added video output to capture session")
            }
            
            self.captureSession.startRunning()

            
        }
        
   
    }
    
    func setOutput() {
        
        let queue = DispatchQueue.global(qos: .background)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        if videoOutput.sampleBufferDelegate != nil {
            print("buffer delegate set")
        }
        
        self.videoOutput.connection(withMediaType: AVMediaTypeVideo)
        
        if videoOutput.connections != nil {
            print("output connections \(videoOutput.connections)")
        
        }
        
        
     
        
        print(captureSession.inputs)
        print(captureSession.outputs)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        print("stuff")
        
    }
    
    
//    func detectFace() {
//        let image = CIImage(image: videoO)
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

