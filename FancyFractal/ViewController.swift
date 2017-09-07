//
//  ViewController.swift
//  FancyFractal
//
//  Created by Daniel Dytert on 23.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

import Cocoa

protocol FractalViewDelegate {
    func mouseClicked(at location: CGPoint)
}

class ViewController: NSViewController, FractalViewDelegate {
    
    private
    var pBitmapBuffer: UnsafeMutablePointer<UInt8>?
    var bitmapBufSize: Int = 0
    var fcWrapper = FCWrapper()
    var bIsRendering = false
    
    @IBOutlet weak var fractalView: FractalView!
    @IBOutlet weak var zoomSlider: NSSlider!
    @IBOutlet weak var renderStatLabel: NSTextField!
    
    @IBAction func resetFractal(_ sender: NSButton) {
        
        guard bIsRendering == false else {
            return
        }
        
        let fs = self.view.frame.size
        
        setupBitmapBuffer(with: fs)
        
        //Create an FCWrapper object and give it a pointer to the freshly created bitmap data array
        fcWrapper = FCWrapper(size: fs, bitmapData:pBitmapBuffer)
        
        bIsRendering = true
        renderStatLabel.isHidden = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fcWrapper.startRendering();
            
            DispatchQueue.main.async {
                self.showFractalImage()
                self.bIsRendering = false
                self.renderStatLabel.isHidden = true
            }
        }

    }
    
    @IBAction func sliderValueChanged(_ sender: NSSlider) {
        
        let zoomSlider = sender
        fractalView.zoomFactor = CGFloat(zoomSlider.doubleValue)
        fractalView.setNeedsDisplay(fractalView.frame)

    }
    
    // Delegate method
    func mouseClicked(at location: CGPoint) {
        
        print("Mouse clicked at: \(location)")
        
        guard bIsRendering == false else {
            return
        }
        bIsRendering = true
        renderStatLabel.isHidden = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fcWrapper.zoomIntoFractal(at: location, withZoom: self.zoomSlider.doubleValue)
            
            DispatchQueue.main.async {
                self.showFractalImage()
                self.bIsRendering = false
                self.renderStatLabel.isHidden = true
            }
        }
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
        
        //print("NSBitmapImageRep created: \(bitmapImageRep)")
        
        self.view.layer?.contents = bitmapImageRep.cgImage
        self.view.needsDisplay = true;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fractalView.delegate = self
        fractalView.zoomFactor = CGFloat(self.zoomSlider.doubleValue)
        
        let fs = self.view.frame.size
        
        setupBitmapBuffer(with: fs)
        
        //Create an FCWrapper object and give it a pointer to the freshly created bitmap data array
        fcWrapper = FCWrapper(size: fs, bitmapData:pBitmapBuffer)
        
        //Custom layer
        self.view.layer = CALayer()
        
        bIsRendering = true
        renderStatLabel.isHidden = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fcWrapper.startRendering();
            
            DispatchQueue.main.async {
                self.showFractalImage()
                self.bIsRendering = false
                self.renderStatLabel.isHidden = true
            }
        }
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


