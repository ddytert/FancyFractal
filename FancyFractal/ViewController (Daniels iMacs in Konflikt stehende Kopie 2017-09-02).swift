//
//  ViewController.swift
//  FancyFractal
//
//  Created by Daniel Dytert on 23.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, CALayerDelegate {
    
    var bitmapImageRep:NSBitmapImageRep?
    weak var updateTimer:Timer?
    var fcWrapper = FCWrapper()
    
    @IBOutlet weak var fractalImageView: NSImageView!
    
    @IBAction func startRendering(_ sender: NSButton) {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                           repeats: true,
                                           block: { (timer) in
                                            print("Timer fired: \(timer)")
                                            //self.showFractalImage()
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
        guard let image = self.bitmapImageRep?.cgImage else {
            print("No CGImage!")
            return
        }
        print("CGImage: \(image)")
        self.view.layer?.contents = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width  = Int(self.view.frame.width)
        let height = Int(self.view.frame.height)
        
        bitmapImageRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                          pixelsWide: width,
                                          pixelsHigh: height,
                                          bitsPerSample: 8,
                                          samplesPerPixel: 4,
                                          hasAlpha: true,
                                          isPlanar: false,
                                          colorSpaceName: NSDeviceRGBColorSpace,
                                          bytesPerRow: width * 4,
                                          bitsPerPixel: 32)
        
        guard let bmpImgRep = bitmapImageRep else {
            return
        }
        //Create an FCWrapper object and give it a pointer to the freshly created bitmap data array
        fcWrapper = FCWrapper(size: self.view.frame.size, bitmapData:bmpImgRep.bitmapData)
        
        //Custom layer
        self.view.layer = CALayer()
    }
    
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}


