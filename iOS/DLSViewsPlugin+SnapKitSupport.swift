//
//  DLSViewsPlugin+SnapKitSupport.swift
//  Snaps
//
//  Created by Akiva Leffert on 9/27/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation
import Dials
import SnapKit

private let identifier = "com.akivaleffert.snaps"

class ConstraintInfo : NSObject, NSCoding {
    let file : String
    let line : Int
    
    init?(constraint : NSLayoutConstraint) {
        if let location = (constraint as? LayoutConstraint)?.snp_constraint?.location {
            self.file = location.file
            self.line = Int(location.line)
            super.init()
        }
        else {
            self.file = ""
            self.line = -1
            super.init()
            return nil
        }
    }

    required init?(coder: NSCoder) {
        if let file = coder.decodeObjectForKey("file") as? String {
            self.file = file
            line = coder.decodeIntegerForKey("line")
            super.init()
        }
        else {
            self.file = ""
            self.line = -1
            super.init()
            return nil
        }
    }
    
    func encodeWithCoder(coder : NSCoder) {
        coder.encodeObject(file, forKey: "file")
        coder.encodeInteger(line, forKey: "line")
    }
}

class ConstraintInformer : NSObject, DLSConstraintInformer {
    func infoForConstraint(constraint: NSLayoutConstraint) -> DLSAuxiliaryConstraintInformation? {
        if let info = ConstraintInfo(constraint: constraint) {
            return DLSAuxiliaryConstraintInformation(pluginIdentifier: identifier, userData: info)
        }
        else {
            return nil
        }
    }
}

extension DLSViewsPlugin {
    public func enableSnapKitSupport() {
        DLSViewsPlugin.activePlugin()?.addAuxiliaryConstraintInformer(ConstraintInformer())
    }
}