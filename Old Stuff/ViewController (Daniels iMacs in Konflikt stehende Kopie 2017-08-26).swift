//
//  ViewController.swift
//  FancyFractal
//
//  Created by Daniel Dytert on 23.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, CALayerDelegate {
    
    var fcWrapper = FCWrapper()
    
    @IBOutlet weak var fractalImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customDrawn = CALayer()
        customDrawn.delegate = self
        
        self.view.layer = customDrawn
        customDrawn.setNeedsDisplay()
        
        //Create an FCWrapper object
        fcWrapper = FCWrapper(size: self.view.frame.size)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    window
    
    // CALayer Delegate method
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
        print("draw layer func called")
        
        let width  = Int(self.view.frame.width)
        let height = Int(self.view.frame.height)
        
    }
    
    
}


