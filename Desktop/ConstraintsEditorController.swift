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
    
    @IBOutlet private var editorView : NSView!
    
    override init() {
        super.init()
        let bundle = NSBundle(forClass: ConstraintsEditorController.classForCoder())
        bundle.loadNibNamed("ConstraintsEditorView", owner: self, topLevelObjects: nil)
    }
    
    var readOnly : Bool {
        return true
    }
    
    var view : NSView {
        return editorView!
    }
}

extension DLSSnapKitConstraintEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        return ConstraintsEditorController()
    }
}
