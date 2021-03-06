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


extension SnapsAuxiliaryConstraintInfo {
    
    convenience init?(constraint : NSLayoutConstraint) {
        if let location = (constraint as? LayoutConstraint)?.snp_location {
            self.init(location : SourceLocation(file: location.file, line: Int(location.line)))
        }
        else {
            return nil
        }
    }
}

class ConstraintInformer : NSObject, DLSConstraintInformer {
    func infoForConstraint(constraint: NSLayoutConstraint) -> DLSAuxiliaryConstraintInformation? {
        return SnapsAuxiliaryConstraintInfo(constraint: constraint)
    }
}

extension DLSViewsPlugin {
    public func enableSnaps() {
        DLSViewsPlugin.activePlugin()?.addAuxiliaryConstraintInformer(ConstraintInformer())
    }
}