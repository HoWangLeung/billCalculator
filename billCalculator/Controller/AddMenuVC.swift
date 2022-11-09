//
//  AddMenuVCViewController.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit
import CoreData
class AddMenuVC: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemPrice: UITextField!
    
    @IBOutlet weak var foodTypeBtn: UIButton!
    
    @IBOutlet weak var drinkTypeBtn: UIButton!
    
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
    
    
    public var completionHandler:((String?,String?,String?)-> Void)?
    
  
    @IBAction func confirmBtnClicked(_ sender: Any) {
        print("confirm add menu item")
      

        completionHandler?(itemName.text, itemPrice.text, itemType.rawValue )
        print("appended succesfully")
        
        dismiss(animated: true)
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
}
