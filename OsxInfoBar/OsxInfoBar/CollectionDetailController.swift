//
//  CollectionDetailController.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//


import Cocoa

//MARK: - Display a collection of images and adjust the size of the view so that all elements are visible.
class CollectionDetailController: NSViewController {
    @IBOutlet weak var collection: NSCollectionView!
    @IBOutlet weak var scroller: NSScrollView!
    
    lazy var _sidebar : SidebarElementContainer? = {
        let sb = NSStoryboard(name: "Headers", bundle: nil)
        guard let h = sb.instantiateControllerWithIdentifier("StandardHeader") as? StandardSidebarHeaderController else {
            return .None
        }
        h.configure(SimpleLabelledSidebarHeader(title: "Images", showLabel: "display", hideLabel: "hide"))
        return SidebarElementContainer(key: "Images", header: h, body: self, state: .Open, hasSeparator: true)
    }()
    
    var sidebar         : SidebarElementContainer? {return _sidebar}
    
    var heightConstraint : [NSLayoutConstraint]?
    var numelements = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clearColor().CGColor
        
        // Must register the cell we're going to use for display in the collection.
        self.collection.registerClass(CollectionCell.self , forItemWithIdentifier: "CollectionCell")
        
        collection.reloadData()
        fixHeight()
    }
}

//MARK: - Collection View Data Source
extension CollectionDetailController : NSCollectionViewDataSource {
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return numelements
    }
    
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        
        let cell = collectionView.makeItemWithIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        
        return cell
    }
}

//MARK: - Collection View Delegate
extension CollectionDetailController : NSCollectionViewDelegate {}

//MARK: - SidebarBodyElement delegate implementation
extension CollectionDetailController : SidebarBodyElement {
    func fixHeight() {
        if let hc = heightConstraint {
            self.view.removeConstraints(hc)
        }
        
        let size = collection.collectionViewLayout?.collectionViewContentSize
        let preferredSize = size!.height
        let m = ["height":preferredSize]
        heightConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[v(==height)]|", options: NSLayoutFormatOptions(), metrics: m, views: ["v":scroller])
        self.view.addConstraints(heightConstraint!)
    }
    
    func canvas(canvas: NSView, frameUpdated f: NSRect) {
        fixHeight()
    }
}