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
            guard isViewLoaded else {return}
            headerText.stringValue = _presenter?.title ?? ""
        }
    }
    
    var toggle       : (() -> ())? // will be set by the sidebar controller to an appropriate action
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.controlColor.cgColor
        
        // Track mouse movement within the header so we can show or hide the show/hide button
        let tracker = NSTrackingArea(rect: self.view.bounds, options: [NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.activeAlways, NSTrackingAreaOptions.inVisibleRect], owner: self , userInfo: nil)
        self.view.addTrackingArea(tracker)
    }
    
    @IBAction func showHidePressed(_ sender: AnyObject) {
        toggle?()
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        showHideBtn.isHidden = false
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        showHideBtn.isHidden = true
    }
}

//MARK: - SidebarHeaderElement implementation
extension StandardSidebarHeaderController : SidebarHeaderElement {
    @discardableResult func configure(_ p: HeaderDetailPresentable) -> Bool {
        guard let pr = p as? SimpleLabelledSidebarHeader else {return false}
        _ = self.view
        _presenter = pr
        return true
    }
    
    func update(toViewState vs : SidebarState) {
        switch vs {
        case .open: showHideBtn.title = _presenter?.hideLabel ?? ""
        case .collapsed: showHideBtn.title = _presenter?.showLabel ?? ""
        }
    }
}
