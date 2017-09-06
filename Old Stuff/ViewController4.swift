//
//  ViewController.swift
//  FancyFractal
//
//  Created by Daniel Dytert on 23.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, CALayerDelegate {
    
    var pBitmapBuffer = UnsafeMutablePointer<UInt8>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customDrawn = CALayer()
        customDrawn.delegate = self
        
        //Create an empty bitmap buffer array
        setupBitmapBuffer(with: self.view.frame.size)
        
        self.view.layer = customDrawn
        customDrawn.setNeedsDisplay()
        
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func setupBitmapBuffer(with size:CGSize) {
        
        let bufSize = Int(size.width * size.height) * 4)
        
        // Allocate memory for bitmap buffer (DEALLOCATE LATER!!!)
        pBitmapBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
        print("Bitmap buffer size: \(size.width) x \(size.height) * 4 = \(bitmapBuffer.count)")
    }
    
    // CALayer Delegate method
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
        let width  = self.view.frame.width
        let height = self.view.frame.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let dataProviderCallback: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?,
            data: UnsafeRawPointer,
            size: Int) -> () in
            return
        }
        
        let optProvider = CGDataProvider(dataInfo: nil,
                                         data: pBitmapBuffer,
                                         size: bitmapBuffer.count,
                                         releaseData: dataProviderCallback)
        
        guard let provider = optProvider else {return}
        
        let optImage = CGImage(width: Int(width),
                               height: Int(height),
                               bitsPerComponent: 8,
                               bitsPerPixel: 32,
                               bytesPerRow: Int(width) * 4,
                               space: colorSpace,
                               bitmapInfo: CGBitmapInfo.alphaInfoMask,
                               provider: provider,
                               decode: nil,
                               shouldInterpolate: false,
                               intent: CGColorRenderingIntent.defaultIntent)
        
        guard let image = optImage else {return}
        
        // Draw
        ctx.draw(image, in: self.view.bounds)
        
        
        
        /* guard let cgImage = bitmapContext.makeImage() else {
         print("image is nil")
         return
         }
         */
    }
    
    
}



