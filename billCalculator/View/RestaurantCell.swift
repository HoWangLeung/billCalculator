//
//  RestaurantCell.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit

class RestaurantCell: UITableViewCell {

   
    @IBOutlet weak var restaurantName: UILabel!
    
    
    func configureCell(restaurantName: String){
        self.restaurantName.text = restaurantName
    }
    
}
