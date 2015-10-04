//
//  ConstraintInfo.swift
//  Snaps
//
//  Created by Akiva Leffert on 10/3/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation

#if os(iOS)
    import Dials
#endif

let PluginIdentifier = "com.akivaleffert.snaps"

class SourceLocation : NSObject, DLSSourceLocation {
    let file : String
    let line : Int
    
    init(file : String, line : Int) {
        self.file = file
        self.line = line
    }
    
    required init?(coder: NSCoder) {
        file = (coder.decodeObjectOfClass(NSString.self, forKey: "file")!) as String
        line = coder.decodeIntegerForKey("line")
        super.init()
    }
    
    func encodeWithCoder(coder : NSCoder) {
        coder.encodeObject(file, forKey: "file")
        coder.encodeInteger(Int(line), forKey: "line")
    }
}

class SnapsAuxiliaryConstraintInfo : NSObject, DLSAuxiliaryConstraintInformation {
    let pluginIdentifier = PluginIdentifier
    let supportsSaving = true
    let sourceLocation : SourceLocation
    
    init(location : SourceLocation) {
        self.sourceLocation = location
    }
    
    required init?(coder : NSCoder) {
        self.sourceLocation = coder.decodeObjectOfClass(SourceLocation.self, forKey: "location")!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(location, forKey: "location")
    }
    
    var location : DLSSourceLocation? {
        return self.sourceLocation
    }
}
