//
//  RestaurantCell.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit

class RestaurantCell: UITableViewCell {

   
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var restaurantAddress: UILabel!
    
    func configureCell(restaurantName: String, restaurantAddress: String){
        self.restaurantName.text = restaurantName
        self.restaurantAddress.text = restaurantAddress
    }
    
}
