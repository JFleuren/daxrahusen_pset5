//
//  AddListItemAlert.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit

// an IBDesignable class UIButton where the user can change certain values in the storyboard
@IBDesignable class RadiusButton: UIButton {
    
    private var _cornerRadius:CGFloat = 0
    
    // define value for cornerRadius
    @IBInspectable var cornerRadius: CGFloat {
        set {
            _cornerRadius = newValue
            makeButtonRound()
        }
        get {
            return _cornerRadius
        }
    }
    
    // the view (button) drawing cycle function
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // set the cornerRadius at the layer
        self.layer.cornerRadius = cornerRadius
        
        // remove viusal outside the new bounds
        self.clipsToBounds = true
    }
    
    private func makeButtonRound() {
        
        if (self._cornerRadius > 0.0) {
            
            // set the cornerRadius at the layer
            self.layer.cornerRadius = cornerRadius
            
            // remove viusal outside the new bounds
            self.clipsToBounds = true
            
        } else {
            
            self.layer.cornerRadius = 0
        }
        
    }
    
    // setState function for (de)enabling the butto state
    func setState(state: Bool) {
        
        // check the give state of the button
        if (state) {
            
            // set the transparantie value of the button
            self.alpha = 1.0
            
            // enable the button
            self.isEnabled = true
            
        } else {
            
            // set the transparantie value of the button
            self.alpha = 0.6
            
            // disable the button
            self.isEnabled = false
        }
    }
    
    
    
}
