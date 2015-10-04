//
//  SnapsPlugin.swift
//  Snaps
//
//  Created by Akiva Leffert on 10/3/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation

class SnapsPlugin : NSObject, Plugin, ConstraintPlugin {
    
    let identifier = PluginIdentifier
    var context : PluginContext?
    let label = "Snaps"
    
    let shouldSortChildren = false
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        self.context = nil
    }
    
    func receiveMessage(message: NSData) {
        
    }

    func saveConstraint(constraint: DLSConstraintDescription) -> NSError? {
        return nil
    }
    
    func displayNameOfConstraint(info: DLSAuxiliaryConstraintInformation) -> String? {
        guard let location = info.location else {
            return nil
        }
        guard let file = try? NSString(contentsOfFile: location.file, encoding: NSUTF8StringEncoding) else {
            return nil
        }
        let lines = file.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        guard lines.count >= location.line else {
            return nil
        }
        guard location.line > 0 else {
            assertionFailure("Unexpected line number: \(location.line)")
            return nil
        }
        let line = lines[location.line - 1]
        guard let range = line.rangeOfString("equalTo(") else {
            return nil
        }
        guard let end = line.rangeOfString(")", options: NSStringCompareOptions(), range: Range(start: range.endIndex, end: line.endIndex), locale: nil) else {
            return nil
        }
        return line[range.endIndex ..< end.startIndex].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}