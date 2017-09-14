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
    let zoomSteps = [0.1, 0.2, 0.3, 0.4, 0.5]
    var zoomFactor = 1.0
    
    // Computed property
    var zoomMultiplier: Double {
        var zm = 1.0
        if zoomModeSwitch.selectedSegment == 0 {
            zm = 10.0
        } else if zoomModeSwitch.selectedSegment == 1 {
            zm = 1.0
        }
        return zm
    }
    
    @IBOutlet weak var fractalView: FractalView!
    @IBOutlet weak var zoomSlider: NSSlider!
    @IBOutlet weak var zoomSliderLabel: NSTextField!
    @IBOutlet weak var renderStatLabel: NSTextField!
    @IBOutlet weak var zoomModeSwitch: NSSegmentedControl!
    
    
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
        zoomFactor = zoomSlider.doubleValue * zoomMultiplier
        
        fractalView.zoomFactor = CGFloat(zoomFactor)
        fractalView.setNeedsDisplay(fractalView.frame)
    }
    
    @IBAction func zoomModeSwitchValueChanged(_ sender: NSSegmentedControl) {
        
        zoomFactor = zoomSlider.doubleValue * zoomMultiplier
        fractalView.zoomFactor = CGFloat(zoomFactor)
        fractalView.setNeedsDisplay(fractalView.frame)
        setupZoomScale()
    }
    
    func setupZoomScale() {
        
        let zm = zoomMultiplier     // Read computed property
        let labelString = String("\(zoomSteps[0]*zm)      \(zoomSteps[1]*zm)       \(zoomSteps[2]*zm)       \(zoomSteps[3]*zm)       \(zoomSteps[4]*zm)")
        zoomSliderLabel.stringValue = labelString!
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
            self.fcWrapper.zoomIntoFractal(at: location, withZoom: self.zoomFactor)
            
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
        
        zoomFactor = zoomSlider.doubleValue * zoomMultiplier
        fractalView.delegate = self
        fractalView.zoomFactor = CGFloat(zoomFactor)
        
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


