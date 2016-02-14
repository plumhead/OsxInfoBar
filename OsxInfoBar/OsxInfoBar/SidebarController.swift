//
//  SidebarController.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
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
        
        let sb = NSStoryboard(name: "Sidebars", bundle: nil)
        let sb1 = sb.instantiateControllerWithIdentifier("DocumentSidebar") as? DocumentDetailSidebar
        
        let sb2 = sb.instantiateControllerWithIdentifier("CanvasSidebar") as? CanvasDetailController
        
        let sb3 = sb.instantiateControllerWithIdentifier("TableSidebar") as? TableDetailController
        
        let sb4 = sb.instantiateControllerWithIdentifier("CollectionSidebar") as? CollectionDetailController
 
        let sb5 = sb.instantiateControllerWithIdentifier("CanvasSidebar") as? CanvasDetailController
        sb5?.useSidebar1 = false
        
        _ = [sb1?.sidebar, sb4?.sidebar, sb2?.sidebar, sb3?.sidebar, sb5?.sidebar]
            .flatMap{$0}
            .map{ addSidebar($0) }
        
        NSNotificationCenter.defaultCenter().addObserver(self , selector: Selector("viewFrameChanged:"), name: NSViewFrameDidChangeNotification, object: self.view)
    }
    
    @IBAction func viewFrameChanged(obj: AnyObject) {
        resized(self.view, toFrame: self.view.frame)
    }
}