//
//  MenuSelectionCell.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit
typealias ButtonHandler = (MenuSelectionCell) -> Void
class MenuSelectionCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    var quantityChangeHandler: ButtonHandler?
    
    func configureCell(name: String, price:NSDecimalNumber, quantity:Int,
                       quantityChangeHandler: ButtonHandler?
    ){
        self.name.text = name
        self.price.text = String(describing: price)
        self.quantity.text = String(describing: quantity)
        self.quantityChangeHandler = quantityChangeHandler
    }
    
     
    @IBAction func didClickSteper(_ sender: UIStepper) {
        print("Current quantity= ",
              String(sender.value)
        )
        self.quantity.text = String(Int(sender.value))
        quantityChangeHandler?(self)
    }
}
