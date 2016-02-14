//
//  CanvasDetailController.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//


import Cocoa

//MARK: - Display 2 boxes and draw a line between the centres
class CanvasDetailController: NSViewController, SidebarBodyElement {
    @IBOutlet weak var leftBox: NSView!
    @IBOutlet weak var rightBox: NSView!
    @IBOutlet var box: BoxView!
    
    // Use the ImageHeader sidebar
    lazy var _sidebar1 : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateControllerWithIdentifier("ImageHeader") as? ImageSidebarHeaderController else {
            return .None
        }

        h.configure(TextSidebarHeader(content: "This is a header view with quite a long title which extends over multiple lines with word wrapping taking place to ensure all text is viewable as expected. This header changes colour depending on current state"))
        return SidebarElementContainer(key: "Canvas1", header: h, body: self, state: .Open, hasSeparator: true)
    }()
    
    // Use the Standard Labelled Header Sidebar
    lazy var _sidebar2 : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateControllerWithIdentifier("StandardHeader") as? StandardSidebarHeaderController else {
            return .None
        }
        
        h.configure(SimpleLabelledSidebarHeader(title: "Canvas", showLabel: "show", hideLabel: "hide"))
        return SidebarElementContainer(key: "Canvas2", header: h, body: self, state: .Open, hasSeparator: true)
    }()

    var useSidebar1 : Bool = true // setup which sidebar header to use.
    var sidebar         : SidebarElementContainer? {return useSidebar1 ? _sidebar1 : _sidebar2}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        leftBox.wantsLayer = true
        leftBox.layer?.backgroundColor = NSColor(calibratedRed: 0.0, green: 1.0, blue: 0.0, alpha: 0.25).CGColor
        
        rightBox.wantsLayer = true
        rightBox.layer?.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.25).CGColor
    }
}


extension CanvasDetailController {
    func resized(canvas: NSView, toFrame f: NSRect) {
        let p1 = NSPoint(x: leftBox.frame.midX, y: leftBox.frame.midY)
        let p2 = NSPoint(x: rightBox.frame.midX, y: rightBox.frame.midY)
        box.points = (p1,p2)
    }
}