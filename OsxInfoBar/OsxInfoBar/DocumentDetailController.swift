//
//  DocumentDetailController.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa

//MARK: - A simple data entry view controller
class DocumentDetailSidebar: NSViewController , SidebarBodyElement{
    lazy var _sidebar : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateController(withIdentifier: "StandardHeader") as? StandardSidebarHeaderController else {
            return .none
        }
        
        h.configure(SimpleLabelledSidebarHeader(title: "Document Options", showLabel: "show", hideLabel: "hide"))
        return SidebarElementContainer(key: "Document", header: h, body: self, state: .open, hasSeparator: true)
    }()
    
    var sidebar         : SidebarElementContainer? {return _sidebar}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.controlColor.cgColor
    }
}
