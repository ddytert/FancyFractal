//
//  ViewController.swift
//  FancyFractal
//
//  Created by Daniel Dytert on 23.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, CALayerDelegate {
    
    var bitmapBuffer = [UInt8]()
    
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
        bitmapBuffer = Array<UInt8>(repeating: 128,
                                    count: Int(size.width * size.height) * 4)
        print("Bitmap buffer size: \(size.width) x \(size.height) * 4 = \(bitmapBuffer.count)")
    }
    
    // CALayer Delegate method
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
        print("draw layer func called")
        
        let width  = Int(self.view.frame.width)
        let height = Int(self.view.frame.height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapFormat = NSBitmapFormat.thirtyTwoBitBigEndian
        
        
 /* If planes is not NULL and the array contains at least one data pointer, the returned object will only reference the image data; it will not copy it. The object treats the image data in the buffers as immutable and will not attempt to alter it. When the object itself is freed, it will not attempt to free the buffers.
 */
        
        let bitmapImage = NSBitmapImageRep(bitmapDataPlanes: &bitmapBuffer,
                                           pixelsWide: width,
                                           pixelsHigh: height,
                                           bitsPerSample: 8,
                                           samplesPerPixel: 4,
                                           hasAlpha: true,
                                           isPlanar: false,
                                           colorSpaceName: NSDeviceRGBColorSpace,
                                           bitmapFormat: bitmapFormat,
                                           bytesPerRow: width * 4,
                                           bitsPerPixel: 32)
        
        let optBitmapCtx = CGContext(data: &bitmapBuffer,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: colorSpace,
                                      bitmapInfo: CGBitmapInfo.alphaInfoMask.rawValue & CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let bitmapCtx = optBitmapCtx else {
            print("bitmap context is nil")
            return
        }
        
        bitmapCtx.setFillColor (red: 1, green: 0, blue: 0, alpha: 1)
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        bitmapCtx.fill(rect)
        
        guard let image = bitmapCtx.makeImage() else {
            print("image is nil")
            return
        }
        
        // Draw
        ctx.draw(image, in: self.view.bounds)
        
        
        /* guard let cgImage = bitmapContext.makeImage() else {
         print("image is nil")
         return
         }
         */
    }
    
    
}


