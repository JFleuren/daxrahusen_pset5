//
//  TodoItemCell.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit

class TodoItemCell: UITableViewCell {
    
    @IBOutlet weak var itemProgressbar: UIProgressView!
    @IBOutlet weak var itemImageView: RoundedImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(todoItem: TodoItem) {
        
        itemProgressbar.progress = calculateProgress(duration: todoItem.duration!)
        
        if todoItem.picture != nil {
            itemImageView.image = UIImage(data: todoItem.picture as! Data)
        } else {
            itemImageView.image = UIImage(named: "")
        }
        
        itemTitle.text = todoItem.title
        
        itemDescription.text = todoItem.subtext
    }
    
    private func calculateProgress(duration: NSDate) -> Float {
        
        return 50.0
    }
    
}
