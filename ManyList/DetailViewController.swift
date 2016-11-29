//
//  DetailViewController.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todoItemTextField: UITextField!
    @IBOutlet weak var todoAddButton: RadiusButton!
    
    var todoList: TodoList!
    var todoItems = [TodoItem]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetSource = self
        
        self.todoItemTextField.delegate = self
        
        let cellNib = UINib(nibName: "TodoItemCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.todoItemCell)
    }

}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.todoItemCell, for: indexPath) as! TodoItemCell
        cell.updateUI(todoItem: todoItems[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

// MARK: - UITextFieldDelegate
extension DetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the range of the between 0 and the amount of characters in the defined textField
        let nounTextFieldRange: NSRange = NSMakeRange(0, (textField.text?.characters.count)!)
        
        // check if the range of the defined textField and the given string are 0
        if (NSEqualRanges(range, nounTextFieldRange) && string.characters.count == 0) {
            
            // set the nounButton state to disabled
            self.todoAddButton.setState(state: false)
            
        } else {
            
            // set the nounButton state to enabled
            self.todoAddButton.setState(state: true)
        }
        
        return true
    }
    
}

//MARK: - DZNEmptyDataSetSource (https://github.com/dzenbot/DZNEmptyDataSet)
extension DetailViewController: DZNEmptyDataSetSource {
    
    // function to define a custom empty text for the empty state view
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        // set the text as NSString
        let text: NSString = "Please add a List item first"
        
        // initialize a paragraphstyle class
        let paragraph = NSMutableParagraphStyle()
        
        // set the paragraph line break mode value to wordWarpping style
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // set the paragraph allignment to center
        paragraph.alignment = NSTextAlignment.center
        
        // define a NSDictionary with text options
        let attr: NSDictionary = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0),
                                   NSForegroundColorAttributeName: UIColor.lightGray,
                                   NSParagraphStyleAttributeName: paragraph
        ]
        
        // return a NSAttributedString object with defined text and attributes parameters
        return NSAttributedString.init(string: text as String, attributes: attr as? [String : Any])
    }
}
