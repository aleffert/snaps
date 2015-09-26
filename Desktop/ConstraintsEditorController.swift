//
//  ConstraintsEditorController.swift
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation
import Cocoa

class ConstraintViewOwner : NSObject {
    @IBOutlet private var constraintView : ConstraintView?
}

class ConstraintView : NSView {
    @IBOutlet private var label : NSTextField!
}

class ConstraintsEditorController : NSObject, EditorController, ViewQuerierOwner {
    weak var delegate : EditorControllerDelegate?
    var viewQuerier : ViewQuerier?
    
    @IBOutlet private var editorView : NSView!
    @IBOutlet private var nothingLabel : NSView!
    @IBOutlet private var constraintStack : NSStackView!
    
    override init() {
        super.init()
        bundle.loadNibNamed("ConstraintsEditorView", owner: self, topLevelObjects: nil)
    }
    
    private lazy var bundle : NSBundle = NSBundle(forClass: ConstraintsEditorController.self)
    
    var readOnly : Bool {
        return true
    }
    
    var view : NSView {
        return editorView!
    }
    
    private func constraintDescription(description : DLSConstraintDescription) -> String {
        guard let source = viewQuerier?.nameForViewWithID(
            description.sourceViewID,
            relativeToView: description.affectedViewID,
            withClass: description.sourceClass,
            file: description.locationFile,
            line: description.locationLine) else {
                return "Internal Error"
        }
        let dest = viewQuerier?.nameForViewWithID(
            description.destinationViewID,
            relativeToView: description.affectedViewID,
            withClass: description.destinationClass,
            file: description.locationFile,
            line: description.locationLine)
        if let destName = dest, destAttribute = description.destinationAttribute {
            var result = "\(source).\(description.sourceAttribute) = \(destName).\(destAttribute)"
            if description.multiplier != 1 {
                result = result + " * \(description.multiplier)"
            }
            if description.constant != 0 {
                result = result + " + \(description.constant)"
            }
            return result
        }
        else {
            return "\(source).\(description.sourceAttribute) = \(description.constant)"
        }
    }
    
    var configuration : EditorConfiguration? {
        didSet {
            if let constraints = configuration?.value as? [DLSConstraintDescription] where constraints.count > 0 {
                constraintStack.hidden = false
                nothingLabel.hidden = true
                constraintStack.setViews([], inGravity: .Top)
                
                for constraint in constraints {
                    let owner = ConstraintViewOwner()
                    bundle.loadNibNamed("ConstraintView", owner: owner, topLevelObjects: nil)
                    if let view = owner.constraintView {
                        view.translatesAutoresizingMaskIntoConstraints = false
                        constraintStack.addView(view, inGravity: .Top)
                        let message = constraintDescription(constraint)
                        view.label.stringValue = message
                    }
                }
            }
            else {
                constraintStack.hidden = true
                nothingLabel.hidden = false
            }
        }
    }
}

extension DLSSnapKitConstraintEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        return ConstraintsEditorController()
    }
}
