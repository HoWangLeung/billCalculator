//
//  MenuItemCellTableViewCell.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var menuItemName: UILabel!
    

    @IBOutlet weak var price: UILabel!
    
    func configureCell(menuItem: MenuItem){
        self.menuItemName.text = menuItem.name
        self.price.text = "£\(menuItem.price ?? 99)"
    }
    
}
