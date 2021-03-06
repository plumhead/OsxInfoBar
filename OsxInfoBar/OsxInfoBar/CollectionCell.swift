//
//  CollectionCell.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa

//MARK: - A simple collection cell which displays a stock image and highlights on selection.
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
