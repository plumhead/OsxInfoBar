//
//  BoxView.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa

class BoxView: NSView {
    
    var points : (NSPoint,NSPoint)? {
        didSet {self.needsDisplay = true}
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let p = points else {return}
        
        let line = NSBezierPath()
        line.lineWidth = 5.0
        line.lineCapStyle = NSLineCapStyle.roundLineCapStyle
        NSColor.blue.setStroke()
        line.move(to: p.0)
        line.line(to: p.1)
        line.stroke()
    }
    
}
