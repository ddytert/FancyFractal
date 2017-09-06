//
//  FractalView.swift
//  FancyFractal
//
//  Created by Daniel Dytert on 02.09.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

import Cocoa

class FractalView: NSView {
    
    public
    var delegate:FractalViewDelegate?
    var zoomFactor:CGFloat = 1.0
    
    private
    var curPoint = NSPoint.zero
    var mouseDown = true
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.configureView()
    }
    
    func configureView() {
        
        // Center zoom rectangle
        curPoint.x = self.frame.size.width / 2.0
        curPoint.y = self.frame.size.height / 2.0
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let rWidth = self.zoomFactor * self.frame.size.width
        let rHeight = self.zoomFactor * self.frame.size.height
        let rXPos = curPoint.x - rWidth / 2
        let rYPos = curPoint.y - rHeight / 2
        
        NSColor.white.set()
        let zoomRect = NSRect(x: rXPos, y: rYPos, width: rWidth, height: rHeight)
        let zoomPath = NSBezierPath(rect: zoomRect)
        zoomPath.stroke()
    }
    
    override func mouseDown(with event: NSEvent) {
        
        curPoint = event.locationInWindow
        mouseDown = true
        self.needsDisplay = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        
        curPoint = event.locationInWindow
        self.needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        
        curPoint = event.locationInWindow
        mouseDown = false
        delegate?.mouseClicked(at: curPoint)
        self.needsDisplay = true
    }

}
