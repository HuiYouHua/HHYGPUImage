//
//  ViewController.swift
//  HHYGPUImage
//
//  Created by 华惠友 on 2020/3/26.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1.获取修改的图片
        let sourceImage = UIImage(named: "test")!
        
        // 2.使用GPUImage高斯模糊
        // 2.1.如果是对图像进行处理GPUImagePicture
        let picProcess = GPUImagePicture(image: sourceImage)
        
        // 2.2.添加u需要处理的滤镜
        let blurFiter = GPUImageGaussianBlurFilter()
        // 设置纹理
        blurFiter.texelSpacingMultiplier = 3
        // 像素点
        blurFiter.blurRadiusInPixels = 5
        picProcess?.addTarget(blurFiter)
        
        // 2.3.处理图片
        blurFiter.useNextFrameForImageCapture()
        picProcess?.processImage()
        
        // 2.4.取出最新的图片
        let newImage = blurFiter.imageFromCurrentFramebuffer()
        
        // 3.显示最新的图片
        imageView.image = newImage
    }

}

