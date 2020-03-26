//
//  ViewController.swift
//  SkinCareGPUImageFilter
//
//  Created by 华惠友 on 2020/3/26.
//  Copyright © 2020 huayoyu. All rights reserved.

import UIKit
import GPUImage

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    fileprivate lazy var camera: GPUImageStillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .front)
    fileprivate lazy var filter = GPUImageBrightnessFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.创建GPUImageStillCamera
        camera.outputImageOrientation = .portrait
        // 2.创建滤镜(美白/曝光)
        filter = GPUImageBrightnessFilter()
        filter.brightness = 0.5
        camera.addTarget(filter)
    
        // 3.创建GPUImageView,用于显示实时画面
        let showView = GPUImageView(frame: view.bounds)
        view.insertSubview(showView, at: 0)
        filter.addTarget(showView)
        
        // 4.开始捕捉画面
        camera.startCapture()
    }

    @IBAction func takephoto(_ sender: Any) {
        camera.capturePhotoAsImageProcessedUp(toFilter: filter) { (image, error) in
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            self.imageView.image = image
            
            self.camera.stopCapture()
        }
    }
    
}

