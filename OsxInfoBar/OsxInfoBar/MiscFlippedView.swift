//
//  MiscFlippedView.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa

// We use these to adjust the origin of stack and scroll views
class FlippedStack : NSStackView {
    override var flipped : Bool {return true}
}

class FlippedScroll : NSScrollView {
    override var flipped : Bool {return true}
}
