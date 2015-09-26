//
//  DLSViewsPlugin+SnapKit.swift
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 7/26/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

import Dials
import SnapKit

private var constraintIDKey : String = ""
private let constraintIDLock = NSLock()
private let constraints = NSMapTable.weakToStrongObjectsMapTable()

extension LayoutConstraint {
    var dls_constraintID : String {
        let result : String
        if let uuid = objc_getAssociatedObject(self, &constraintIDKey) as? String {
            result = uuid
        }
        else {
            constraintIDLock.lock()
            if let uuid = objc_getAssociatedObject(self, &constraintIDKey) as? String {
                result = uuid
            }
            else {
                result = NSUUID().UUIDString
                constraints.setObject(result, forKey: self)
                objc_setAssociatedObject(self, &constraintIDKey, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        return result
    }
}

extension NSLayoutAttribute {
    var portableValue : String {
        switch self {
        case .Left: return "left"
        case .Right: return "right"
        case .Top: return "top"
        case .Bottom: return "bottom"
        case .Leading: return "leading"
        case .Trailing: return "trailing"
        case .Width: return "width"
        case .Height: return "height"
        case .CenterX: return "centerX"
        case .CenterY: return "centerY"
        case .Baseline: return "baseline"
        case .FirstBaseline: return "firstBaseline"
        case .LeftMargin: return "leftMargin"
        case .RightMargin: return "rightMargin"
        case .TopMargin: return "topMargin"
        case .BottomMargin: return "bottomMargin"
        case .LeadingMargin: return "leadingMargin"
        case .TrailingMargin: return "trailingMargin"
        case .CenterXWithinMargins: return "centerXWithinMargins"
        case .CenterYWithinMargins: return "CenterYWithinMargins"
        case .NotAnAttribute: return "notAnAttribute"
        }
    }
}

extension DLSConstraintDescription {
    convenience init(constraint : LayoutConstraint, view : UIView) {
        self.init()
        let source : AnyObject = constraint.firstItem
        let destination : AnyObject? = constraint.secondItem
        constraintID = constraint.dls_constraintID
        sourceClass = source.dynamicType.description()
        destinationClass = destination?.dynamicType.description()
        label = constraint.snp_label
        locationFile = constraint.snp_constraint?.location?.file
        constant = constraint.constant
        multiplier = constraint.multiplier
        active = constraint.active
        sourceAttribute = constraint.firstAttribute.portableValue
        destinationAttribute = constraint.secondAttribute.portableValue
    }
}


private func extractConstraintsFromView(view : UIView) -> [DLSConstraintDescription] {
    let constraints = view.constraintsAffectingLayoutForAxis(.Horizontal) + view.constraintsAffectingLayoutForAxis(.Vertical)
    let layoutConstraints = constraints.flatMap { c -> [DLSConstraintDescription] in
        if let layoutConstraint = c as? LayoutConstraint {
            return [DLSConstraintDescription(constraint: layoutConstraint, view: view)]
        }
        else {
            return []
        }
    }
    return layoutConstraints
}

class DLSSnapKitConstraintsExchanger : DLSValueExchanger {
    init() {
        super.init(
            from: { object in
                {
                    if let view = object as? UIView {
                        return extractConstraintsFromView(view)
                    }
                    else {
                        return []
                    }
                }
            },
            to: { object in
                { value in
                    // TODO
                }
            }
        )
    }
}

extension DLSViewsPlugin {
    public func enableSnapKitSupport() {
        self.addExtraViewDescriptionForClass(UIView.classForCoder()) {context in
            context.addGroupWithName("Constraints", properties:
                [
                    DLSProperty("Constraints", DLSSnapKitConstraintEditor()).setExchanger(DLSSnapKitConstraintsExchanger())
                ]
            )
        }
    }
}
