//
//  TableDetailController.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//
import Cocoa

//MARK: - Display a simple table of text which adjusts to ensure content all visible in view.
class TableDetailController: NSViewController {
    @IBOutlet weak var targetTable: NSScrollView!
    @IBOutlet weak var contentTable: NSTableView!
    
    lazy var _sidebar : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateControllerWithIdentifier("StandardHeader") as? StandardSidebarHeaderController else {
            return .None
        }

        h.configure(SimpleLabelledSidebarHeader(title: "Table", showLabel: "show", hideLabel: "hide"))
        return SidebarElementContainer(key: "Table", header: h, body: self, state: .Collapsed, hasSeparator: true)
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


//MARK: - Table View Data Source Implementation
extension TableDetailController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return numrows
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeViewWithIdentifier("NavCell", owner: self) as? NSTableCellView else {
            return .None
        }
        
        cell.textField?.stringValue = "This is row \(row)"
        return cell
    }
}

// MARK: - Table View Delegate Implementation
extension TableDetailController : NSTableViewDelegate {}

//MARK: - Make sure that when the 'host' canvas changes size the table content height is adjusted accordingly
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
    
    func resized(canvas: NSView, toFrame f: NSRect) {
        fixTableSize()
    }
}