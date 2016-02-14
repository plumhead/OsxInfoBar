//
//  SidebarDomain.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa



//MARK:- Indicates whether the content view is visible or collapsed
enum SidebarState {
    case Open
    case Collapsed
}

// MARK: - Configuration for Sidebar headers
protocol HeaderDetailPresentable{}

//MARK: - Elements which can be collapsed or expanded
protocol ExpandableElement {
    func contentWillCollapse()
    func contentDidCollapse()
    func contentWillExpand()
    func contentDidExpand()
}

//MARK: - Represents a view which can be resized
protocol ResizableViewHost {
    func resized(canvas: NSView, toFrame f: NSRect)
}

//MARK: - Controlling Protocol for Sidebar headers
protocol SidebarHeaderElement : class , ResizableViewHost{
    var controller   : NSViewController {get}
    var toggle       : (() -> ())? {get set}
    
    @warn_unused_result func configure(p: HeaderDetailPresentable) -> Bool
    func update(toViewState vs : SidebarState)
}

//MARK: - Controlling Protocol for the Sidebar content views
protocol SidebarBodyElement : class , ExpandableElement, ResizableViewHost {
    var controller  : NSViewController {get}
    
    func show()
    func hide()
}


//MARK: - The master view (usually StackView) holding the set of sidebar containers
protocol SidebarHost : class, ResizableViewHost {
    typealias ViewType
    var hostView        : ViewType {get}
    var hostController  : NSViewController {get}
    var content         : [String:SidebarElementContainer] {get set}
    
    func addSidebar(element : SidebarElementContainer) -> Bool
    func toggle(element: SidebarElementContainer)
    func show(element: SidebarElementContainer)
    func hide(element: SidebarElementContainer)
}

//MARK: - A container to capture the relationship between a header and it's associated content controller
class SidebarElementContainer {
    let key     : String
    let header  : SidebarHeaderElement
    let body    : SidebarBodyElement
    var state   : SidebarState
    var hasSeparator : Bool
    
    init(key: String, header: SidebarHeaderElement, body: SidebarBodyElement, state: SidebarState, hasSeparator: Bool = false) {
        self.key = key
        self.header = header
        self.body = body
        self.state = state
        self.hasSeparator = hasSeparator
    }
}



//MARK: - Simple configuration structure for basic labelled headers
struct SimpleLabelledSidebarHeader : HeaderDetailPresentable {
    let title       : String
    let showLabel   : String
    let hideLabel   : String
}


//MARK: - A custom configuration for headers with just a text content field
struct TextSidebarHeader  : HeaderDetailPresentable {
    let content : String
}


// ---- We can start building out some default implementations here -----


//MARK: - Sidebar header default implementations
extension SidebarHeaderElement {
    func resized(canvas: NSView, toFrame f: NSRect) {} // default noop
}

//MARK: - Sidebar header standard controller implementations
extension SidebarHeaderElement where Self : NSViewController {
    var controller : NSViewController {return self}
}

//MARK: - ExpandableElement default noop implementations
extension ExpandableElement {
    func contentWillCollapse() {} // default noop
    func contentDidCollapse() {} // default noop
    func contentWillExpand() {} // default noop
    func contentDidExpand() {} // default noop
}

//MARK: - Resizable Host default noop implementations
extension ResizableViewHost {
    func resized(canvas: NSView, toFrame f: NSRect) {} // default noop
}

extension SidebarBodyElement where Self : NSViewController {
    // If attached to a ViewController then we can provide default implementations
    // A more advanced show/hide could add effects (advanced animation etc)
    func show() {self.view.hidden = false}
    func hide() {self.view.hidden = true}
    var controller : NSViewController {return self}
}


//MARK: - Standard SideBarHost Implementations
extension SidebarHost {
    func toggle(element: SidebarElementContainer) {
        switch element.state {
        case .Open: // move to collapse
            hide(element)
            element.state = .Collapsed
            
        case .Collapsed : // move to open
            show(element)
            element.state = .Open
        }
        
        element.header.update(toViewState: element.state)
    }
    
    func show(element: SidebarElementContainer) {
        element.body.contentWillExpand()
        element.body.show()
        element.body.contentDidExpand()
        element.header.update(toViewState: .Open)
    }
    
    func hide(element: SidebarElementContainer) {
        element.body.contentWillCollapse()
        element.body.hide()
        element.body.contentDidCollapse()
        element.header.update(toViewState: .Collapsed)
    }
    
    func resized(canvas: NSView, toFrame f: NSRect) {
        for (_,v) in content {
            v.header.resized(canvas, toFrame: f)
            v.body.resized(canvas, toFrame: f)
        }
    }
}

//MARK: - An NSStackView implementation of the SidebarHost addSidebar.
extension SidebarHost where ViewType == NSStackView {
    func addSidebar(element : SidebarElementContainer) -> Bool {
        // Make sure we haven't already added a container with the same key
        guard content[element.key] == nil else {return false}
        
        // Set the appropriate action for when the header view 'toggles state'
        element.header.toggle = {[unowned self] in
            self.toggle(element)
        }
        
        // If we want to add a default separator then setup here
        if element.hasSeparator {
            let box = NSBox()
            box.boxType = NSBoxType.Separator
            box.translatesAutoresizingMaskIntoConstraints = false
            hostView.addArrangedSubview(box)
        }
        
        // Add our header view
        hostView.addArrangedSubview(element.header.controller.view)
        
        // Add the main content view
        hostView.addArrangedSubview(element.body.controller.view)
        
        // Make sure the appropriate view controllers are added as children of the current controller
        hostController.addChildViewController(element.body.controller)
        hostController.addChildViewController(element.header.controller)
        
        // Fix the current state
        switch element.state {
        case .Open      : show(element)
        case .Collapsed : hide(element)
        }
        
        // Record the
        content[element.key] = element
        return true
    }
}

















