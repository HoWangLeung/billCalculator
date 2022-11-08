//
//  MenuSelectionCell.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit

class MenuSelectionCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    
    
    func configureCell(name: String, price:NSDecimalNumber, quantity:Int ){
        self.name.text = name
        self.price.text = String(describing: price)
        self.quantity.text = String(describing: quantity)
        
    }
    
//    @IBAction func stepperClicked(_ sender: UIStepper) {
//        print("stepper value=", Int(sender.value).description )
//    }
    
}
