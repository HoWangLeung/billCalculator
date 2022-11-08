//
//  GroupCell.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit

class GroupCell: UITableViewCell {

   
    @IBOutlet weak var groupName: UILabel!
    
    func configureCell(groupName: String){
        self.groupName.text = groupName
    }
    
    
    
}
