//
//  ConstraintView.swift
//  Snaps
//
//  Created by Akiva Leffert on 9/26/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Cocoa


class ConstraintViewOwner : NSObject {
    @IBOutlet var constraintView : ConstraintView?
}

protocol ConstraintViewDelegate : class {
    func constraintView(constraintView : ConstraintView, choseHighlightViewWithID viewID: String)
    func constraintView(constraintView : ConstraintView, clearedHighlightViewWithID viewID: String)
    func constraintView(constraintView : ConstraintView, selectedViewWithID viewID: String)
}

class ConstraintView : NSView {
    weak var delegate : ConstraintViewDelegate?
    
    @IBOutlet private var first : NSTextField!
    @IBOutlet private var relation : NSTextField!
    @IBOutlet private var second : NSTextField!
    
    var constraint : DLSConstraintDescription? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        let firstArea = NSTrackingArea(rect: NSZeroRect, options: [.ActiveInActiveApp, .MouseEnteredAndExited, .InVisibleRect], owner: self, userInfo: ["view" : first])
        first.addTrackingArea(firstArea)
        
        let secondArea = NSTrackingArea(rect: NSZeroRect, options: [.ActiveInActiveApp, .MouseEnteredAndExited, .InVisibleRect], owner: self, userInfo: ["view" : second])
        second.addTrackingArea(secondArea)
        
        let firstChosenGesture = NSClickGestureRecognizer(target: self, action: Selector("firstChosen:"))
        firstChosenGesture.numberOfClicksRequired = 2
        first.addGestureRecognizer(firstChosenGesture)
        
        let secondChosenGesture = NSClickGestureRecognizer(target: self, action: Selector("secondChosen:"))
        secondChosenGesture.numberOfClicksRequired = 2
        second.addGestureRecognizer(secondChosenGesture)
    }
    
    func firstChosen(theEvent: NSEvent) {
        if let viewID = constraint?.sourceViewID {
            self.delegate?.constraintView(self, selectedViewWithID: viewID)
        }
    }
    
    func secondChosen(theEvent: NSEvent) {
        if let viewID = constraint?.destinationViewID {
            self.delegate?.constraintView(self, selectedViewWithID: viewID)
        }
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        
        if let view = theEvent.trackingArea?.userInfo?["view"] as? NSView {
            if let viewID = constraint?.sourceViewID where view == first {
                self.delegate?.constraintView(self, choseHighlightViewWithID:viewID)
            }
            else if let viewID = constraint?.destinationViewID where view == second {
                self.delegate?.constraintView(self, choseHighlightViewWithID:viewID)
            }
        }
        else {
            assertionFailure("no tracking view found")
        }
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        
        if let view = theEvent.trackingArea?.userInfo?["view"] as? NSView {
            if let viewID = constraint?.sourceViewID where view == first {
                self.delegate?.constraintView(self, clearedHighlightViewWithID:viewID)
            }
            else if let viewID = constraint?.destinationViewID where view == second {
                self.delegate?.constraintView(self, clearedHighlightViewWithID:viewID)
            }
        }
        else {
            assertionFailure("no tracking view found")
        }
    }
    
    var fields : (first : String, relation : String, second : String) = ("", "", "") {
        didSet {
            first.stringValue = fields.first
            relation.stringValue = fields.relation
            second.stringValue = fields.second
        }
    }
}