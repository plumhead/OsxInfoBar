//
//  StandardSidebarHeaderController.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa

//MARK: - A standard header with a title and a show/hide button
class StandardSidebarHeaderController : NSViewController {
    @IBOutlet weak var headerText: NSTextField!
    @IBOutlet weak var showHideBtn: NSButton!
    
    var _presenter   : SimpleLabelledSidebarHeader? {
        didSet {
            guard viewLoaded else {return}
            headerText.stringValue = _presenter?.title ?? ""
        }
    }
    
    var toggle       : (() -> ())? // will be set by the sidebar controller to an appropriate action
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.controlColor().CGColor
        
        // Track mouse movement within the header so we can show or hide the show/hide button
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

//MARK: - SidebarHeaderElement implementation
extension StandardSidebarHeaderController : SidebarHeaderElement {
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