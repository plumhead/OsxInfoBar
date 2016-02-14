//
//  CanvasDetailController.swift
//  OsxInfoBar
//
//  Created by Plumhead on 14/02/2016.
//  Copyright © 2016 Andy Calderbank. All rights reserved.
//


import Cocoa

class CanvasDetailController: NSViewController, SidebarBodyElement {
    @IBOutlet weak var leftBox: NSView!
    @IBOutlet weak var rightBox: NSView!
    @IBOutlet var box: BoxView!
    
    lazy var _sidebar : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateControllerWithIdentifier("ImageHeader") as? ImageSidebarHeaderController else {
            return .None
        }

        h.configure(TextSidebarHeader(content: "This is a header view with quite a long title which extends over multiple lines with word wrapping taking place to ensure all text is viewable as expected. This header changes colour depending on current state"))
        return SidebarElementContainer(key: "Canvas", header: h, body: self, state: .Open, hasSeparator: true)
    }()
    
    var sidebar         : SidebarElementContainer? {return _sidebar}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        leftBox.wantsLayer = true
        leftBox.layer?.backgroundColor = NSColor(calibratedRed: 0.0, green: 1.0, blue: 0.0, alpha: 0.25).CGColor
        
        rightBox.wantsLayer = true
        rightBox.layer?.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.25).CGColor
    }
}


extension CanvasDetailController {
    func canvas(canvas: NSView, frameUpdated f: NSRect) {
        let p1 = NSPoint(x: leftBox.frame.midX, y: leftBox.frame.midY)
        let p2 = NSPoint(x: rightBox.frame.midX, y: rightBox.frame.midY)
        box.points = (p1,p2)
    }
}