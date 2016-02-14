//
//  SidebarDomain.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa



//MARK:- Indicates whether the content view is visible or collapsed
public enum SidebarState {
    case Open
    case Collapsed
}

// MARK: - Configuration for Sidebar headers
public protocol HeaderDetailPresentable{}

//MARK: - Simple configuration structure for basic labelled headers
public struct SimpleLabelledSidebarHeader : HeaderDetailPresentable {
    public let title       : String
    public let showLabel   : String
    public let hideLabel   : String
    
    public init(title: String, showLabel: String, hideLabel: String) {
        self.title = title
        self.showLabel = showLabel
        self.hideLabel = hideLabel
    }
}

//MARK: - Simple configuration structure for basic labelled headers
public struct EditableLabelledSidebarHeader : HeaderDetailPresentable {
    public struct EditOptions : OptionSetType {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let AddNewItem = EditOptions(rawValue: 0)
        public static let DeleteItems = EditOptions(rawValue: 1)
    }
    public let title       : String
    public let showLabel   : String
    public let hideLabel   : String
    public let options     : EditOptions
    
    public init(title: String, showLabel: String, hideLabel: String, options: EditOptions) {
        self.title = title
        self.showLabel = showLabel
        self.hideLabel = hideLabel
        self.options = options
    }
}

//MARK: - A custom configuration for headers with just a text content field
public struct TextSidebarHeader  : HeaderDetailPresentable {
    public let content : String
    public init(content: String) {
        self.content = content
    }
}


//MARK: - Controlling Protocol for Sidebar headers
public protocol SidebarHeaderElement : class {
    var controller   : NSViewController {get}
    var toggle       : (() -> ())? {get set}
    
    @warn_unused_result func configure(p: HeaderDetailPresentable) -> Bool
    func update(toViewState vs : SidebarState)
    func canvas(canvas: NSView, frameUpdated f: NSRect)
}

//MARK: - Sidebar header default implementations
public extension SidebarHeaderElement {
    func canvas(canvas: NSView, frameUpdated f: NSRect) {} // default noop
}

//MARK: - Sidebar header standard controller implementations
public extension SidebarHeaderElement where Self : NSViewController {
    var controller : NSViewController {return self}
}

//MARK: - Controlling Protocol for the Sidebar content views
public protocol SidebarBodyElement : class {
    var controller  : NSViewController {get}
    
    func show()
    func hide()
    func contentWillCollapse()
    func contentDidCollapse()
    func contentWillExpand()
    func contentDidExpand()
    func canvas(canvas: NSView, frameUpdated f: NSRect)
}

//MARK: - Sidebar content default noop implementations
public extension SidebarBodyElement {
    func canvas(canvas: NSView, frameUpdated f: NSRect) {} // default noop
    func contentWillCollapse() {} // default noop
    func contentDidCollapse() {} // default noop
    func contentWillExpand() {} // default noop
    func contentDidExpand() {} // default noop
}

public extension SidebarBodyElement where Self : NSViewController {
    func show() {self.view.hidden = false}
    func hide() {self.view.hidden = true}
    var controller : NSViewController {return self}
    var contentView : NSView {return self.view}
}

//MARK: - A container to capture the relationship between a header and it's associated content controller
public class SidebarElementContainer {
    public let key     : String
    public let header  : SidebarHeaderElement
    public let body    : SidebarBodyElement
    public var state   : SidebarState
    public var hasSeparator : Bool
    
    public init(key: String, header: SidebarHeaderElement, body: SidebarBodyElement, state: SidebarState, hasSeparator: Bool = false) {
        self.key = key
        self.header = header
        self.body = body
        self.state = state
        self.hasSeparator = hasSeparator
    }
}

//MARK: - The master view (usually StackView) holding the set of sidebar containers
public protocol SidebarHost : class {
    typealias ViewType
    var hostView       : ViewType {get}
    var hostController : NSViewController {get}
    var content : [String:SidebarElementContainer] {get set}
    
    func addSidebar(element : SidebarElementContainer) -> Bool
    func toggle(element: SidebarElementContainer)
    func show(element: SidebarElementContainer)
    func hide(element: SidebarElementContainer)
    func canvas(canvas: NSView, frameUpdated f: NSRect)
}

//MARK: - Standard SideBarHost Implementations
public extension SidebarHost {
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
    }
    
    func hide(element: SidebarElementContainer) {
        element.body.contentWillCollapse()
        element.body.hide()
        element.body.contentDidCollapse()
    }
    
    func canvas(canvas: NSView, frameUpdated f: NSRect) {
        for (_,v) in content {
            v.header.canvas(canvas, frameUpdated: f)
            v.body.canvas(canvas, frameUpdated: f)
        }
    }
}

//MARK: - An NSStackView implementation of the SidebarHost addSidebar.
public extension SidebarHost where ViewType == NSStackView {
    func addSidebar(element : SidebarElementContainer) -> Bool {
        // Make sure we haven't already added a container with the same key
        guard content[element.key] == nil else {return false}
        
        // Set the appropriate action for when the header view 'toggles state'
        element.header.toggle = {[unowned self] in
            self.toggle(element)
        }
        
        
        // If we want to add a default separator then setup here
        if element.hasSeparator {
            let box1 = NSBox()
            box1.boxType = NSBoxType.Separator
            box1.translatesAutoresizingMaskIntoConstraints = false
            hostView.addArrangedSubview(box1)
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
        
        content[element.key] = element
        element.header.update(toViewState: element.state)
        return true
    }
}

















