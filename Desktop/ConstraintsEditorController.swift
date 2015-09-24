//
//  ConstraintsEditorController.swift
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation
import Cocoa

class ConstraintsEditorController : NSObject, EditorController {
    weak var delegate : EditorControllerDelegate?
    var configuration : EditorConfiguration?
    
    var readOnly : Bool {
        return true
    }
    
    var view : NSView {
        return NSView(frame : NSRect(x : 0, y : 0, width : 100, height : 100))
    }
}