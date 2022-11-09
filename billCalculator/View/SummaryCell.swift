//
//  SummaryCell.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit

class SummaryCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    func configureCell(name: String, price:NSDecimalNumber, quantity:Int
                     
    ){
        self.name.text = name
        self.price.text = String(describing: price)
        self.quantity.text = String(describing: quantity)
       
    }
    
    
 

}
