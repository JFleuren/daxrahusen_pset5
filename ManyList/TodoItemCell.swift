//
//  TodoItemCell.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit
import DateTools

class TodoItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: RoundedImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(todoItem: TodoItem) {
        
        if todoItem.picture != nil {
            itemImageView.image = UIImage(data: todoItem.picture as! Data)
        } else {
            itemImageView.image = UIImage(named: "image_placeholder")
        }
        
        itemTitle.text = todoItem.title
        
        itemDescription.text = todoItem.subtext
    }
}
