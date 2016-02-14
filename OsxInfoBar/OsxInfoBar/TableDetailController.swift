//
//  TableDetailController.swift
//  OsxInfoBar
//
//  Created by Plumhead on 14/02/2016.
//  Copyright © 2016 Andy Calderbank. All rights reserved.
//
import Cocoa

class TableDetailController: NSViewController {
    @IBOutlet weak var targetTable: NSScrollView!
    @IBOutlet weak var contentTable: NSTableView!
    
    lazy var _sidebar : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateControllerWithIdentifier("StandardHeader") as? StandardSidebarHeaderController else {
            return .None
        }

        h.configure(SimpleLabelledSidebarHeader(title: "Structure", showLabel: "show", hideLabel: "hide"))
        return SidebarElementContainer(key: "Structure", header: h, body: self, state: .Collapsed, hasSeparator: true)
    }()
    
    var sidebar         : SidebarElementContainer? {return _sidebar}
    
    var tableHeightConstraint : [NSLayoutConstraint]?
    var numrows = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.orangeColor().CGColor
        
        fixTableSize()
    }
}



extension TableDetailController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return numrows
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeViewWithIdentifier("NavCell", owner: self) as? NSTableCellView else {
            return .None
        }
        
        cell.textField?.stringValue = "I am row \(row) with a long description which may wrap around the cell if the table width is adjusted"
        
        return cell
    }
}


extension TableDetailController : NSTableViewDelegate {
}


extension TableDetailController : SidebarBodyElement {
    
    func fixTableSize() {
        if let hc = tableHeightConstraint {
            self.view.removeConstraints(hc)
        }
        
        let preferredSize = numrows * 20
        let m = ["height":preferredSize]
        tableHeightConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[v(==height)]|", options: NSLayoutFormatOptions(), metrics: m, views: ["v":targetTable])
        self.view.addConstraints(tableHeightConstraint!)
    }
    
    func contentWillExpand() {
        fixTableSize()
    }
}