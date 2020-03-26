//
//  ViewController.swift
//  RealTimeGPUImage
//
//  Created by 华惠友 on 2020/3/26.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {
    
    fileprivate lazy var camera: GPUImageVideoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.medium.rawValue, cameraPosition: .front)
    fileprivate lazy var filter = GPUImageBrightnessFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.创建相机
        camera.delegate = self
        camera.outputImageOrientation = .portrait
        // 2.添加滤镜
        camera.addTarget(filter)
        
        // 3.添加一个用于实时显示画面的GPUImageView
        let showView = GPUImageView(frame: view.bounds)
        view.insertSubview(showView, at: 0)
        filter.addTarget(showView)
        
        // 4.开始采集画面
        camera.startCapture()
        
    }
    
    
}

extension ViewController: GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        print("采集到的画面")
    }
}


