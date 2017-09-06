//
//  ViewController.swift
//  FancyFractal
//
//  Created by Daniel Dytert on 23.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var pBitmapBuffer: UnsafeMutablePointer<UInt8>?
    var bitmapBufSize: Int = 0
    weak var updateTimer:Timer?
    var fcWrapper = FCWrapper()
    
    @IBOutlet weak var fractalImageView: NSImageView!
    
    @IBAction func startRendering(_ sender: NSButton) {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                           repeats: true,
                                           block: { (timer) in
                                            print("Timer fired: \(timer)")
                                            self.showFractalImage()
        })
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fcWrapper.startRendering();
            self.updateTimer?.invalidate()
            DispatchQueue.main.async {
                self.showFractalImage()
            }
        }
    }
    
    @IBAction func showFractal(_ sender: NSButton) {
        showFractalImage()
    }
    
    func showFractalImage() {
        
        let width  = Int(self.view.frame.width)
        let height = Int(self.view.frame.height)
        
        // Create NSBitmapImageRep from bitmap buffer
        let optBitmapImageRep = NSBitmapImageRep(bitmapDataPlanes: &pBitmapBuffer,
                                              pixelsWide: width,
                                              pixelsHigh: height,
                                              bitsPerSample: 8,
                                              samplesPerPixel: 4,
                                              hasAlpha: true,
                                              isPlanar: false,
                                              colorSpaceName: NSDeviceRGBColorSpace,
                                              bytesPerRow: width * 4,
                                              bitsPerPixel: 32)
        
        guard let bitmapImageRep = optBitmapImageRep else {
            return
        }
        
        print("NSBitmapImageRep created: \(bitmapImageRep)")
        
        self.view.layer?.contents = bitmapImageRep.cgImage
        self.view.needsDisplay = true;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fs = self.view.frame.size
        
        setupBitmapBuffer(with: fs)
        
        //Create an FCWrapper object and give it a pointer to the freshly created bitmap data array
        fcWrapper = FCWrapper(size: fs, bitmapData:pBitmapBuffer)
        
        //Custom layer
        self.view.layer = CALayer()
    }
    
    func setupBitmapBuffer(with size:CGSize) {
        
        if pBitmapBuffer != nil {
            pBitmapBuffer?.deallocate(capacity: bitmapBufSize)
        }
        
        let bSize = Int(size.width * size.height) * 4
        
        // Allocate memory for bitmap buffer (DEALLOCATE LATER!!!)
        pBitmapBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bSize)
        print("Bitmap buffer size: \(size.width) x \(size.height) * 4 = \(bSize)")
        
        bitmapBufSize = bSize
}
    
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}


