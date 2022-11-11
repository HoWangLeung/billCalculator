//
//  AddMenuVCViewController.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit
import CoreData
class AddEditMenuVC: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemPrice: UITextField!
    
    @IBOutlet weak var foodTypeBtn: UIButton!
    
    @IBOutlet weak var drinkTypeBtn: UIButton!
    
    var currentRestaurant:Restaurant? = nil
    
    var isEditMode = false
    
    var itemType: ItemType = .food
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTypeBtn.setSelectedColour()
        drinkTypeBtn.setDeselectedColour()
    }
    
    @IBAction func foodTypeBtnWasPressed(_ sender: Any) {
        itemType = .food
        foodTypeBtn.setSelectedColour()
        drinkTypeBtn.setDeselectedColour()
    }
    
    
    @IBAction func drinkTypeBtnWasPressed(_ sender: Any) {
        itemType = .drink
        foodTypeBtn.setDeselectedColour()
        drinkTypeBtn.setSelectedColour()
    }
    
    
    public var completionHandler:(()-> Void)?
    public var  completionHandlerEdit:((String?, NSDecimalNumber?, String?)-> Void)?
    
  
    @IBAction func confirmBtnClicked(_ sender: Any) {
        print("confirm add menu item")
      
        if itemName.text != ""  && itemPrice.text != nil {
            
          
            if isEditMode {
                let name = itemName.text!
                let price = NSDecimalNumber(string: itemPrice.text!)
                let type = itemType.rawValue
                completionHandlerEdit?(name,price,type)
                
            }else{
                let menuItem: MenuItem = DataManager.shared.menuItem(name: itemName.text!, price: NSDecimalNumber(string: itemPrice.text!), type: itemType.rawValue)
                currentRestaurant?.addToMenuItems(menuItem)
                completionHandler?()
            }
            
            
           
            print("appended succesfully")
            
            dismiss(animated: true)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Pleaes fill in the required fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
     
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    
}
