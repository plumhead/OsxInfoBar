//
//  StandardSidebarHeaderController.swift
//  OsxInfoBar
//
//  Created by Plumhead on 14/02/2016.
//  Copyright © 2016 Andy Calderbank. All rights reserved.
//

import Cocoa

class StandardSidebarHeaderController : NSViewController, SidebarHeaderElement {
    @IBOutlet weak var headerText: NSTextField!
    @IBOutlet weak var showHideBtn: NSButton!
    
    var _presenter   : SimpleLabelledSidebarHeader? {
        didSet {
        guard viewLoaded else {return}
        headerText.stringValue = _presenter?.title ?? ""
        }
    }
    
    var toggle       : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.controlColor().CGColor
        
        let tracker = NSTrackingArea(rect: self.view.bounds, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveAlways, NSTrackingAreaOptions.InVisibleRect], owner: self , userInfo: nil)
        self.view.addTrackingArea(tracker)
    }
    
    @IBAction func showHidePressed(sender: AnyObject) {
        toggle?()
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        showHideBtn.hidden = false
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        showHideBtn.hidden = true
    }
}

extension StandardSidebarHeaderController  {
    func configure(p: HeaderDetailPresentable) -> Bool {
        guard let pr = p as? SimpleLabelledSidebarHeader else {return false}
        _ = self.view
        _presenter = pr
        return true
    }
    
    func update(toViewState vs : SidebarState) {
        switch vs {
        case .Open: showHideBtn.title = _presenter?.hideLabel ?? ""
        case .Collapsed: showHideBtn.title = _presenter?.showLabel ?? ""
        }
    }
}