//
//  AddListItemAlert.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import Foundation
import UIKit

class AddListItemAlert: UIAlertController {
    
    // completionHandler
    typealias Completion = (_ succeed: Bool, _ text: String?) -> Void

    // function which the user can edit the selected To-Do item subject in an UIAlertController
    func addListView(controller: UIViewController, completionHandler: @escaping Completion) {
        
        // initialize a alertcontroller alert style, with title and message wit
        let editAlert = UIAlertController(title: "Add a To-Do list", message: "Enter the title of the To-Do list", preferredStyle: .alert)
        
        // add a textfield to the alertcontroller
        editAlert.addTextField() { (textField) in
            
            // set the 'current' To-Do subjects text in the textfield
            textField.placeholder = ""
            
            // set a clearbutton while the user is editing
            textField.clearButtonMode = .whileEditing
        }
        
        // add a cancele action to the alertcontroller
        editAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            // tell the completion handle it failed to edit the row
            completionHandler(false, nil)
        })
        
        editAlert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            
            // tell the completion handle it succeed to add the row
            // and put the new text is parameter to the completion handler
            completionHandler(true, editAlert.textFields?.first?.text)
        })
        
        // present the alertcontroller with animated options
        controller.present(editAlert, animated: true, completion: nil)
    }


}
