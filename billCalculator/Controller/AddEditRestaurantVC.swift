//
//  GroupsVC.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit
import CoreData
class AddEditRestaurantVC: UIViewController {
    
    
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var restaurantName: UITextField!
    
    var currentRestaurant:Restaurant? = nil
    
    var menuItems:[MenuItem] = []
    
    var isEditMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if isEditMode {
            mainTitle.text = "Edit Restaurant"
            self.restaurantName.text = currentRestaurant?.restaurantName
            let arr = currentRestaurant?.menuItems?.allObjects as! [MenuItem]
            self.menuItems = arr
        }
        
    }
    
    
    @IBAction func didTapAddBtn(_ sender: Any) {
        print("did tap add button")
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddEditMenuVC") as! AddEditMenuVC
        vc.completionHandler = {itemName,itemPrice, itemType in
            print("received",itemName,itemPrice)
            var newitemPrice = NSDecimalNumber(string: itemPrice)
            let menuItem = DataManager.shared.menuItem(name: itemName!, price: newitemPrice, type: itemType!)
            
            self.menuItems.append(menuItem)
            self.tableView.reloadData()
        }
        vc.modalPresentationStyle = .fullScreen
        
        present(vc,animated: true)
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnWasPressed(_ sender: Any) {
        print("clicked")
        if restaurantName.text != "" {
           
            
            if isEditMode {
                print("restaurantName.text ",self.restaurantName.text)
                currentRestaurant?.restaurantName = self.restaurantName.text
                
                
                self.save{ (complete) in
                    if complete {
                        dismiss(animated: true)
                    }
                }
              
            }else{//edit
                let restaurant = DataManager.shared.restaurant(restaurantName: restaurantName.text!)
                for menuItem in menuItems {
                    restaurant.addToMenuItems(menuItem)
                }
                
                self.save{ (complete) in
                    if complete {
                        dismiss(animated: true)
                    }
                    
                }
            }
        }
 
    }
    

    func save(completion:(_ finished:Bool)->()){
     
        
        
       
        
         
        DataManager.shared.save()
        completion(true)

    }
    
}

extension AddEditRestaurantVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
 
        let menuItem = self.menuItems[indexPath.row]
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as? MenuItemCell else {
            return UITableViewCell() }
         cell.configureCell(menuItem: menuItem)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    //For Edit and Delete Starts
    
    private func deleteAction(rowIndexPathAt indexPath: IndexPath) ->
    UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (_,_,_) in
           
            
            let fetchedItem:MenuItem = DataManager.shared.getOneMenuItem(menuItem: self.menuItems[indexPath.row])!
            if fetchedItem != nil {
                print("delete in db")
            }else{
                print("nil it is")
            }
            self.menuItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return action
    }
    private func editAction (rowIndexPathAt indexPath: IndexPath) ->
    UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit"){ (_,_,_) in
            print("pressed Edit in swipe")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditMenuVC") as! AddEditMenuVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: true)
        }
        action.backgroundColor = .systemMint
        return action
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.deleteAction(rowIndexPathAt: indexPath)
        let editionAction = self.editAction(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction,editionAction])
        return swipe
    }
    
    //For Edit and Delete Ends
    

    
    
}
