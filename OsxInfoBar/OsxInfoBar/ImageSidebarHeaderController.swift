//
//  ImageSidebarHeaderController.swift
//  OsxInfoBar
//
//  Created by Plumhead on 14/02/2016.
//  Copyright © 2016 Andy Calderbank. All rights reserved.
//

import Cocoa

class ImageSidebarHeaderController: NSViewController, SidebarHeaderElement {
    @IBOutlet weak var titleLabel: NSTextField!
    
    var _presenter : TextSidebarHeader? {
        didSet {
        guard viewLoaded else {return}
        titleLabel.stringValue = _presenter?.content ?? ""
        }
    }
    
    var toggle       : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
    }
    
    @IBAction func showHidePressed(sender: AnyObject) {
        toggle?()
    }
}

extension ImageSidebarHeaderController {
    func configure(p: HeaderDetailPresentable) -> Bool {
        guard let pr = p as? TextSidebarHeader else {return false}
        _ = self.view
        _presenter = pr
        return true
    }
    
    func update(toViewState vs : SidebarState) {
        switch vs {
        case .Open:
            self.view.layer?.backgroundColor = NSColor.greenColor().CGColor
        case .Collapsed:
            let c = NSColor(calibratedRed: 1.0, green: 0.0, blue: 0.0, alpha: 0.25)
            self.view.layer?.backgroundColor = c.CGColor
        }
    }
}