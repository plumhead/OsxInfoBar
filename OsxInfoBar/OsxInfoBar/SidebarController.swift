//
//  SidebarController.swift
//  OsxInfoBar
//
//  Created by Plumhead on 14/02/2016.
//  Copyright © 2016 Andy Calderbank. All rights reserved.
//


import Cocoa

//MARK: - Basic Stack based Sidebar controller
class SidebarController: NSViewController , SidebarHost {
    @IBOutlet weak var scroller: FlippedScroll!
    @IBOutlet weak var stack: FlippedStack!
    
    //MARK:- Sidebar delegate
    typealias ViewType = NSStackView
    var content : [String:SidebarElementContainer] = [:]
    var hostView : NSStackView {return stack}
    var hostController : NSViewController {return self}
    
    //MARK: - View Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let sb = NSStoryboard(name: "Sidebars", bundle: nil)
        let sb1 = sb.instantiateControllerWithIdentifier("DocumentSidebar") as? DocumentDetailSidebar
        let _ = sb1?.view // force load
        
        let sb2 = sb.instantiateControllerWithIdentifier("CanvasSidebar") as? CanvasDetailController
        let _ = sb2?.view // force load
        
        let sb3 = sb.instantiateControllerWithIdentifier("TableSidebar") as? TableDetailController
        let _ = sb3?.view // force load
        
        let sb4 = sb.instantiateControllerWithIdentifier("CollectionSidebar") as? CollectionDetailController
        let _ = sb4?.view // force load
        
        _ = [sb1!.sidebar, sb4!.sidebar, sb2!.sidebar, sb3!.sidebar]
            .flatMap{$0}
            .map{ addSidebar($0) }
        
        NSNotificationCenter.defaultCenter().addObserver(self , selector: Selector("viewFrameChanged:"), name: NSViewFrameDidChangeNotification, object: self.view)
    }
    
    @IBAction func viewFrameChanged(obj: AnyObject) {
        canvas(self.view, frameUpdated: self.view.frame)
    }
}