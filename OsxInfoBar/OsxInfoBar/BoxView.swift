//
//  BoxView.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa

class BoxView: NSView {
    
    var points : (NSPoint,NSPoint)? {
        didSet {
        self.needsDisplay = true
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        guard let p = points else {return}
        
        let line = NSBezierPath()
        line.lineWidth = 5.0
        line.lineCapStyle = NSLineCapStyle.RoundLineCapStyle
        NSColor.blueColor().setStroke()
        line.moveToPoint(p.0)
        line.lineToPoint(p.1)
        line.stroke()
    }
    
}
