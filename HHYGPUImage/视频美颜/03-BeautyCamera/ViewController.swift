//
//  ViewController.swift
//  03-BeautyCamera
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import UIKit
import GPUImage
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var beautyViewBottomCons: NSLayoutConstraint!
    
    // MARK: 懒加载属性
    // 创建视频源
    fileprivate lazy var camera : GPUImageVideoCamera? = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .front)
    
    // 创建预览图层
    fileprivate lazy var preview : GPUImageView = GPUImageView(frame: self.view.bounds)
    
    // 初始化滤镜
    let bilateralFilter = GPUImageBilateralFilter() // 磨皮
    let exposureFilter = GPUImageExposureFilter() // 曝光
    let brightnessFilter = GPUImageBrightnessFilter() // 美白
    let satureationFilter = GPUImageSaturationFilter() // 饱和
    
    // 创建写入对象
    fileprivate lazy var movieWriter : GPUImageMovieWriter = { [unowned self] in
        // 创建写入对象
        let writer = GPUImageMovieWriter(movieURL: self.fileURL, size: self.view.bounds.size)
        
        // 设置写入对象的属性
        
        return writer!
    }()
    
    // MARK: 计算属性
    var fileURL : URL {
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())123.mp4")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(fileURL)
        
        // 1.设置camera方向
        camera?.outputImageOrientation = .portrait
        camera?.horizontallyMirrorFrontFacingCamera = true
        
        // 2.创建预览的View
        view.insertSubview(preview, at: 0)
        
        // 3.获取滤镜组
        let filterGroup = getGroupFilters()
        
        // 4.设置GPUImage的响应链
        camera?.addTarget(filterGroup)
        filterGroup.addTarget(preview)
        
        // 5.开始采集视频
        camera?.startCapture()
        
        // 6.设置writer的属性
        // 是否对视频进行编码
        movieWriter.encodingLiveVideo = true
        
        // 将writer设置成滤镜的target
        filterGroup.addTarget(movieWriter)
        
        // 设置camera的编码
        camera?.delegate = self
        camera?.audioEncodingTarget = movieWriter
        
        movieWriter.startRecording()
    }
    
    
    fileprivate func getGroupFilters() -> GPUImageFilterGroup {
        // 1.创建滤镜组（用于存放各种滤镜：美白、磨皮等等）
        let filterGroup = GPUImageFilterGroup()
        
        // 2.创建滤镜(设置滤镜的引来关系)
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(satureationFilter)
        
        // 3.设置滤镜组链初始&终点的filter
        filterGroup.initialFilters = [bilateralFilter]
        filterGroup.terminalFilter = satureationFilter
        
        return filterGroup
    }
}


// MARK:- 控制方法
extension ViewController {
    @IBAction func rotateCamera() {
        camera?.rotateCamera()
    }
    
    @IBAction func adjustBeautyEffect() {
        adjustBeautyView(constant: 0)
    }
    
    @IBAction func finishedBeautyEffect() {
        adjustBeautyView(constant: -250)
    }
    
    @IBAction func switchBeautyEffect(switchBtn : UISwitch) {
        if switchBtn.isOn {
            camera?.removeAllTargets()
            let group = getGroupFilters()
            camera?.addTarget(group)
            group.addTarget(preview)
        } else {
            camera?.removeAllTargets()
            camera?.addTarget(preview)
        }
    }
    
    private func adjustBeautyView(constant : CGFloat) {
        beautyViewBottomCons.constant = constant
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func changeSatureation(_ sender: UISlider) {
        satureationFilter.saturation = CGFloat(sender.value * 2)
    }
    
    @IBAction func changeBrightness(_ sender: UISlider) {
        // - 1 --> 1
        brightnessFilter.brightness = CGFloat(sender.value) * 2 - 1
    }
    
    @IBAction func changeExposure(_ sender: UISlider) {
        // - 10 ~ 10
        exposureFilter.exposure = CGFloat(sender.value) * 20 - 10
    }
    
    @IBAction func changeBilateral(_ sender: UISlider) {
        bilateralFilter.distanceNormalizationFactor = CGFloat(sender.value) * 8
    }
}

extension ViewController : GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        print("采集到画面")
    }
}

extension ViewController {
    @IBAction func stopRecording() {
        camera?.stopCapture()
        preview.removeFromSuperview()
        movieWriter.finishRecording()
    }
    
    @IBAction func playVideo() {
        print(fileURL)
        let playerVc = AVPlayerViewController()
        playerVc.player = AVPlayer(url: fileURL)
        present(playerVc, animated: true, completion: nil)
    }
}

