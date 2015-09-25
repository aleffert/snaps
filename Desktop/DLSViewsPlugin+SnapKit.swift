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

class DLSConstraintDescription : NSObject, NSCoding {
    let label : String?
    
    let sourceClass : String
    let sourceAttribute : NSLayoutAttribute
    let destinationClass : String?
    let destinationAttribute : NSLayoutAttribute
    
    let constraintID : String
    let location : SourceLocation?
    let constant : CGFloat
    let multiplier : CGFloat
    let active : Bool
    
    init(constraint : LayoutConstraint, view : UIView) {
        let source : AnyObject = constraint.firstItem
        let destination : AnyObject? = constraint.secondItem
        constraintID = constraint.dls_constraintID
        sourceClass = source.dynamicType.description()
        destinationClass = destination?.dynamicType.description()
        label = constraint.snp_label
        location = constraint.snp_constraint?.location
        constant = constraint.constant
        multiplier = constraint.multiplier
        active = constraint.active
        sourceAttribute = constraint.firstAttribute
        destinationAttribute = constraint.secondAttribute
    }
    
    required init(coder aDecoder: NSCoder) {
        self.constraintID = aDecoder.decodeObjectForKey("constraintID") as? String ?? ""
        self.sourceClass = aDecoder.decodeObjectForKey("sourceClass") as? String ?? ""
        self.sourceAttribute = NSLayoutAttribute(rawValue: aDecoder.decodeIntegerForKey("sourceAttribute")) ?? .NotAnAttribute
        
        self.destinationClass = aDecoder.decodeObjectForKey("destinationClass") as? String ?? ""
        self.destinationAttribute = NSLayoutAttribute(rawValue: aDecoder.decodeIntegerForKey("destinationAttribute")) ?? .NotAnAttribute
        
        self.label = aDecoder.decodeObjectForKey("label") as? String ?? ""
        self.location = SourceLocation(serializedRepresentation:aDecoder.decodeObjectForKey("location") as? [String:AnyObject] ?? [:])
        self.multiplier = CGFloat(aDecoder.decodeDoubleForKey("multiplier"))
        self.constant = CGFloat(aDecoder.decodeDoubleForKey("constant"))
        self.active = aDecoder.decodeBoolForKey("active")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.constraintID, forKey: "constraintID")
        aCoder.encodeObject(self.sourceClass, forKey: "sourceClass")
        aCoder.encodeInteger(self.sourceAttribute.rawValue, forKey: "sourceAttribute")
        
        aCoder.encodeObject(self.destinationClass, forKey: "destinationClass")
        aCoder.encodeInteger(self.destinationAttribute.rawValue, forKey: "destinationAttribute")
        
        aCoder.encodeObject(self.label, forKey: "label")
        aCoder.encodeObject(self.location?.serializedRepresentation, forKey: "location")
        aCoder.encodeDouble(Double(self.multiplier), forKey: "multiplier")
        aCoder.encodeDouble(Double(self.constant), forKey: "constant")
        aCoder.encodeBool(self.active, forKey: "active")
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
