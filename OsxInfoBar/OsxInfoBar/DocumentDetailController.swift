//
//  DocumentDetailController.swift
//  OsxInfoBar
//
//  Created by Plumhead on 14/02/2016.
//  Copyright © 2016 Andy Calderbank. All rights reserved.
//

import Cocoa

class DocumentDetailSidebar: NSViewController , SidebarBodyElement{
    lazy var _sidebar : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateControllerWithIdentifier("StandardHeader") as? StandardSidebarHeaderController else {
            return .None
        }
        
        h.configure(SimpleLabelledSidebarHeader(title: "Document Options", showLabel: "show", hideLabel: "hide"))
        return SidebarElementContainer(key: "Document", header: h, body: self, state: .Open, hasSeparator: true)
    }()
    
    var sidebar         : SidebarElementContainer? {return _sidebar}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.orangeColor().CGColor
    }
}
