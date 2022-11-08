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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public var completionHandler:((String?,String?)-> Void)?
    
  
    @IBAction func confirmBtnClicked(_ sender: Any) {
        print("confirm add menu item")
//        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
//        let menuItem = MenuItem(context: managedContext)
//        menuItem.name = itemName.text
//
//        if let str = itemPrice.text,
//            let itemPrice = Int32(str) {
//            menuItem.price = itemPrice
//        }
      

        completionHandler?(itemName.text, itemPrice.text )
        print("appended succesfully")
        
        dismiss(animated: true)
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
}
