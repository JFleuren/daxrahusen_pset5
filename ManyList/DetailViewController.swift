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
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todoItemTextField: UITextField!
    @IBOutlet weak var todoAddButton: RadiusButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    // defined properties
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>!
    var todoList: TodoList?
    var imageData: NSData?
    
    // initialized properties
    var todoItems = [TodoItem]()
    var imagePicked = false
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNewData(manager: CoreDataManager.sharedInstance.managedObjectContext)
        
        setTextFieldBoardState()
    }

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        
        todoItemTextField.delegate = self
        
        let cellNib = UINib(nibName: "TodoItemCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.todoItemCell)
    
        // set a Notification listener for when the Keyboard will be shown
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // set a Notification listener for when the Keyboard will be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // set a Notification listener for when the user submited a new list
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.setTextFieldBoardState), name: NotificationsIdentifiers.TEXTFIELDSTATE, object: nil)
        
        // set a Notification listener for when the Keyboard will be hidden
    }
    
    //MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        // remove the Notification listeners when the view will disapear
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NotificationsIdentifiers.TEXTFIELDSTATE, object: nil)
        super.viewWillDisappear(animated)
    }
    
    // function which fetch new data from the DataBase
    private func fetchNewData(manager: NSManagedObjectContext) {
        
        todoItems.removeAll()
        
        if todoList != nil {
            
            navigationController?.navigationItem.title = todoList!.title
            
            // set the fetchrequest to the entity table 'ToDoList'
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataClasses.TODOITEM)
            
            // filter for the given To-DO Items with giving To-Do List
            let predicate = NSPredicate(format: "listId = %@", todoList!.id!)
            
            fetchRequest.predicate = predicate
            
            do {
                
                // try to fetch the new (up to date) To-Do items from Database
                todoItems = try manager.fetch(fetchRequest) as! [TodoItem]
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        // reload the tableview
        tableView.reloadData()
    }
    
    @IBAction func cameraButtonClicked(_ sender: RadiusButton) {
        
        let todoImagePicker = UIImagePickerController()
        todoImagePicker.allowsEditing = false
        todoImagePicker.sourceType = .photoLibrary
        todoImagePicker.delegate = self
        present(todoImagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func AddItemClicked(_ sender: RadiusButton) {
        
        // get the appropriate table path for writing newly objects
        let entity = NSEntityDescription.entity(forEntityName: CoreDataClasses.TODOITEM, in: CoreDataManager.sharedInstance.managedObjectContext)
        
        let todoItem = TodoItem(entity: entity!, insertInto: CoreDataManager.sharedInstance.managedObjectContext)
        todoItem.listId = todoList?.id
        todoItem.title = todoItemTextField.text
        todoItem.subtext = ""
        todoItem.finished = false
        todoItem.picture = imagePicked ? imageData : nil
        
        todoItems.append(todoItem)
        
        CoreDataManager.sharedInstance.saveContext()
        
        tableView.beginUpdates()
        
        let indexPath = IndexPath(row: todoItems.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
        
        todoItemTextField.text = ""
        todoItemTextField.resignFirstResponder()
    }
    
    // function which sets the textfield interactions state
    func setTextFieldBoardState() {
        if todoList != nil {
            todoItemTextField.isUserInteractionEnabled = true
        } else {
            todoItemTextField.isUserInteractionEnabled = false
        }
    }
    
    // function which calculates the keyboard height and set the views new y in canvas
    func keyboardWasShown(notification: NSNotification) {
        
        // get the notification information
        let info = notification.userInfo!
        
        // get the keybaord size value from the info dictory and cast as a CGRect
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey]! as! NSValue).cgRectValue
        
        // get the keyboards height frame
        let keyboardHeight = keyboardSize.height
        
        // set the views bottom constant to the keyboard height
        bottomConstraint.constant = keyboardHeight
        
        // animate the view the to the new y state
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // function which set the views to original y in canvas
    func keyboardWillBeHidden(notification: NSNotification) {
        
        // set the bottom constant to original: 0
        bottomConstraint.constant = 0
        
        // animate the the view to original view state
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            cell.accessoryType = todoItems[indexPath.row].finished ? .checkmark : .none
            todoItems[indexPath.row].toggleChecked()
        }
        
        CoreDataManager.sharedInstance.saveContext()
        
        tableView.deselectRow(at: indexPath, animated: true)
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

// MARK: - DZNEmptyDataSetSource (https://github.com/dzenbot/DZNEmptyDataSet)
extension DetailViewController: DZNEmptyDataSetSource {
    
    // function to define a custom empty text for the empty state view
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var text: NSString!
        
        // set the text as NSString depending on To-Do items value
        if todoItems.isEmpty {
            text = "Please add a List item first"
        } else {
            text = "Write your first To-Do item!!"
        }
        
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

// MARK: - UIImagePickerControllerDelegate
extension DetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicked = false
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let compressedImageData = UIImagePNGRepresentation(pickedImage)
            
            imageData = compressedImageData as NSData?
        }
        
        imagePicked = true
        
        dismiss(animated: true, completion: nil)
    }
}
