//
//  MiscFlippedView.swift
//  OsxInfoBar
//
//  Created by @PlumheadDev on 14/02/2016.
//

import Cocoa

class FlippedStack : NSStackView {
    override var flipped : Bool {return true}
}

class FlippedScroll : NSScrollView {
    override var flipped : Bool {return true}
}
