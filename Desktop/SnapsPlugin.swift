//
//  SnapsPlugin.swift
//  Snaps
//
//  Created by Akiva Leffert on 10/3/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation

enum SaveError : ErrorType {
    case UnableToFindLine
    case MissingEqualTo
    case UnableToParse
    case InternalError
}

class SnapsPlugin : NSObject, Plugin, ConstraintPlugin, CodeHelperOwner {
    
    let identifier = PluginIdentifier
    var context : PluginContext?
    var codeHelper : CodeHelper?
    
    let label = "Snaps"
    
    let shouldSortChildren = false
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        self.context = nil
    }
    
    func receiveMessage(message: NSData) {
        // No known messages
    }
    
    func isNumeric(string : String) -> Bool {
        return Float(string) != nil
    }
    
    func stringFromNumber(value : CGFloat) -> String {
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.alwaysShowsDecimalSeparator = false
        formatter.minimumIntegerDigits = 1
        return formatter.stringFromNumber(value)!
    }
    
    private func lineAtLocation(location : DLSSourceLocation?) -> (String, [String])? {
        // TODO: Consider caching this
        guard let location = location else {
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
        return (line, lines)
    }
    
    // Given a string containing something like "abc.def.name(foo)" and the string "name" 
    // returns "foo"
    func argumentOfFunction(name : String, inString line: String) -> (body: String, range: Range<String.Index>)? {
        // TODO: Make this more robust in case of things like new lines or nested parens
        guard let head = line.rangeOfString(name) else {
            return nil
        }
        
        guard let start = line.rangeOfString("(", options: NSStringCompareOptions(), range: Range(start:head.endIndex, end:line.endIndex), locale: nil) else {
            return nil
        }
        guard let end = line.rangeOfString(")", options: NSStringCompareOptions(), range: Range(start:start.endIndex, end:line.endIndex), locale: nil) else {
            return nil
        }
        
        let range = start.endIndex ..< end.startIndex
        let body = line[range].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return (body: body, range: range)
    }

    // This is pretty hacky. TODO: Expand to more cases. Probably should actually just do 
    // an expression parse starting at the given line.
    func saveConstraint(info: DLSAuxiliaryConstraintInformation, constant : CGFloat) throws {
        func error(error : SaveError) -> NSError {
            return error as NSError
        }
        guard let lineInfo = lineAtLocation(info.location) else {
            throw error(.UnableToFindLine)
        }
        let line = lineInfo.0
        var lines = lineInfo.1
        
        let code = stringFromNumber(constant)
        
        // First look for an offset operation
        if let (body, range) = argumentOfFunction("offset", inString:line) {
            // If found. Try to replace the value directly
            if isNumeric(body) {
                let newLine = line.stringByReplacingCharactersInRange(range, withString: code)
                lines[info.location!.line - 1] = newLine
            }
            else {
                // Otherwise, it's a symbol. Try to update the symbol
                guard let codeHelper = codeHelper else {
                    throw error(.InternalError)
                }
                try codeHelper.updateSymbol(body, toCode: code, inLanguage: .Swift, atURL: NSURL(fileURLWithPath:info.location!.file))
            }
        }
        else {
            // No offset. So look if we're setting a value directly
            guard let (body, range) = argumentOfFunction("equalTo", inString:line) else {
                throw error(.UnableToParse)
            }
            let newLine : String
            if isNumeric(body) {
                newLine = line.stringByReplacingCharactersInRange(range, withString: "\(code)")
            }
            else {
                do {
                    // Try to find the symbol and replace
                    guard let codeHelper = codeHelper else {
                        throw SaveError.InternalError
                    }
                    try codeHelper.updateSymbol(body, toCode: code, inLanguage: .Swift, atURL: NSURL(fileURLWithPath:info.location!.file))
                    return
                }
                catch {
                    // Otherwise, just insert an "offset" operation
                    guard let insertion = line.rangeOfString(")", options: NSStringCompareOptions(), range: Range(start:range.endIndex, end:line.endIndex), locale: nil) else {
                        throw SaveError.UnableToParse
                    }
                    newLine = line.stringByReplacingCharactersInRange(Range(start:insertion.endIndex, end:insertion.endIndex), withString: ".offset(\(code))")
                }
            }
            lines[info.location!.line - 1] = newLine
        }
        
        let joined = lines.joinWithSeparator("\n")
        try joined.writeToFile(info.location!.file, atomically: true, encoding: NSUTF8StringEncoding)
    }
    
    func displayNameOfConstraint(info: DLSAuxiliaryConstraintInformation) -> String? {
        guard let (line, _) = lineAtLocation(info.location) else {
            return nil
        }
        guard let (body, _) = argumentOfFunction("equalTo", inString:line) else {
            return nil
        }
        return body
    }
}