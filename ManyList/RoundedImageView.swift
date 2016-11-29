//
//  RoundedImageView.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit

// an IBDesignable class UIImageView where the user can change certain values in the storyboard
@IBDesignable class RoundedImageView: UIImageView {
    
    // initialize private variable
    private var _round = false
    
    // set the round value to the value in defined in the storyboard
    // get the round value from the private varibale
    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeImageRound()
        }
        get {
            return _round
        }
    }
    
    // override the frame function of the imageview
    override internal var frame: CGRect {
        set {
            super.frame = newValue
            makeImageRound()
        }
        get {
            return super.frame
        }
    }
    
    // function which changes the properies of the UIImageViews layer and contentmode
    private func makeImageRound() {
        
        self.contentMode = .scaleAspectFill
        
        if (self.round) {
            self.clipsToBounds = true
            self.layer.cornerRadius = self.frame.width / 2
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
    override func layoutSubviews() {
        makeImageRound()
    }
    
}

