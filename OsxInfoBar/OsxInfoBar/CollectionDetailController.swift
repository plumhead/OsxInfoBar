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
        guard let h = sb.instantiateController(withIdentifier: "StandardHeader") as? StandardSidebarHeaderController else {
            return .none
        }
        h.configure(SimpleLabelledSidebarHeader(title: "Images", showLabel: "display", hideLabel: "hide"))
        return SidebarElementContainer(key: "Images", header: h, body: self, state: .open, hasSeparator: true)
    }()
    
    var sidebar         : SidebarElementContainer? {return _sidebar}
    
    var heightConstraint : [NSLayoutConstraint]?
    var numelements = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Must register the cell we're going to use for display in the collection.
        self.collection.register(CollectionCell.self , forItemWithIdentifier: "CollectionCell")
        
        collection.reloadData()
        fixHeight()
    }
}

//MARK: - Collection View Data Source
extension CollectionDetailController : NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return numelements
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let cell = collectionView.makeItem(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
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
        heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v(==height)]|", options: NSLayoutFormatOptions(), metrics: m as [String : NSNumber]?, views: ["v":scroller])
        self.view.addConstraints(heightConstraint!)
    }
    
    func resized(_ canvas: NSView, toFrame f: NSRect) {
        fixHeight()
    }
}
