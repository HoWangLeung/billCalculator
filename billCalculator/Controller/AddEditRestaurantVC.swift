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

    @IBOutlet weak var restaurantAddress: UITextField!
    
    var currentRestaurant:Restaurant? = nil
    
    var itemsToBeDeletedFromContext:[MenuItem] = []
    
    var isEditMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        restaurantName.text = self.currentRestaurant?.restaurantName
      
        
    }
    
    
    @IBAction func didTapAddBtn(_ sender: Any) {
        print("did tap add button")
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddEditMenuVC") as! AddEditMenuVC
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
        
        vc.currentRestaurant = self.currentRestaurant
        vc.completionHandler = {self.tableView.reloadData()}
    
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        if !isEditMode {DataManager.shared.persistentContainer.viewContext.delete(self.currentRestaurant!)}
       // if isEditMode {DataManager.shared.persistentContainer.viewContext.delete(self.currentRestaurant?.menuItems)}
        DataManager.shared.persistentContainer.viewContext.reset()
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnWasPressed(_ sender: Any) {
        print("clicked")
        if restaurantName.text != "" && restaurantAddress.text != "" {
            currentRestaurant?.restaurantName = restaurantName.text
            currentRestaurant?.address = restaurantAddress.text
            
            for item in itemsToBeDeletedFromContext {
                DataManager.shared.persistentContainer.viewContext.delete(item)
            }
            self.save{ completion in
                if completion {
                    self.dismiss(animated: true)
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
        return (currentRestaurant?.menuItems!.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menuItems = self.currentRestaurant?.menuItems?.allObjects as! [MenuItem]
        let menuItem =  menuItems[indexPath.row]
      
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditMenuVC") as! AddEditMenuVC
        vc.modalPresentationStyle = .fullScreen
        vc.isEditMode = true
        self.present(vc,animated: true)
        let menuItems = self.currentRestaurant?.menuItems?.allObjects as! [MenuItem]
        let menuItem =  menuItems[indexPath.row]
        
        vc.itemName.text = menuItem.name!
        vc.itemPrice.text = String(describing:menuItem.price!)
        vc.currentRestaurant = currentRestaurant
        vc.isEditMode = true
        vc.completionHandlerEdit = { name,price,type in
            menuItem.name = name
            menuItem.price = price
            menuItem.type = type
            
           tableView.reloadData()
        }
    }
    
    private func deleteAction(rowIndexPathAt indexPath: IndexPath) ->
    UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (_,_,_) in
            
          
           // DataManager.shared.persistentContainer.viewContext.delete( self.currentRestaurant?.menuItems[indexPath.row])
            let menuItems = self.currentRestaurant?.menuItems?.allObjects as! [MenuItem]
            let menuItem =  menuItems[indexPath.row]
            self.currentRestaurant?.removeFromMenuItems(menuItem)
            self.itemsToBeDeletedFromContext.append(menuItem)
            
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return action
    }

    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.deleteAction(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipe
    }
    
    //For Edit and Delete Ends
    

    
    
}
