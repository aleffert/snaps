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
}