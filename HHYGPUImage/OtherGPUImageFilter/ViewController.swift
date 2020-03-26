//
//  ViewController.swift
//  OtherGPUImageFilter
//
//  Created by 华惠友 on 2020/3/26.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    fileprivate lazy var image: UIImage = UIImage(named: "test")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func hese(_ sender: Any) {
        let fiter = GPUImageSepiaFilter()
        imageView.image = processImage(fiter)
    }
    
    @IBAction func katong(_ sender: Any) {
        let fiter = GPUImageToonFilter()
        imageView.image = processImage(fiter)
    }
    
    @IBAction func sumiao(_ sender: Any) {
        let fiter = GPUImageSketchFilter()
        imageView.image = processImage(fiter)
    }
        
    @IBAction func fudiao(_ sender: Any) {
        let fiter = GPUImageEmbossFilter()
        imageView.image = processImage(fiter)
    }
    
    private func processImage(_ filter: GPUImageFilter) -> UIImage? {
        let picProcess = GPUImagePicture(image: image)
        picProcess?.addTarget(filter)
        
        filter.useNextFrameForImageCapture()
        picProcess?.processImage()
        
        let newImage = filter.imageFromCurrentFramebuffer()
        return newImage
    }
}

