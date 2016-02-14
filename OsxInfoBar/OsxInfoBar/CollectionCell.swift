//
//  CollectionCell.swift
//  OsxInfoBar
//
//  Created by Plumhead on 14/02/2016.
//  Copyright © 2016 Andy Calderbank. All rights reserved.
//

import Cocoa

class CollectionCell: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    }
    
    override var selected : Bool {
        didSet {
        if selected {
            self.view.layer?.borderColor = NSColor.greenColor().CGColor
            self.view.layer?.borderWidth = 4
        }
        else {
            self.view.layer?.borderWidth = 0
        }
        }
    }

}
