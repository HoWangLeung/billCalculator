//
//  EachGroupVC.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit

class EachGroupVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentRestaurant:Restaurant!
    
    var menuItemsForSelection:[MenuItem] = []
    var currentRestaurantId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let restaurant = self.currentRestaurant
        let menuItems = DataManager.shared.getMenuItemsByRestaurant(currentRestaurant: currentRestaurant)
        self.menuItemsForSelection = menuItems
//        DataManager.shared.ge
    }
    
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    

}

extension EachGroupVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemsForSelection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menuItem = self.menuItemsForSelection[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuSelectionCell") as? MenuSelectionCell else {
            return UITableViewCell() }
        cell.configureCell(name: menuItem.name!,price:menuItem.price ?? 0, quantity:1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
  
  
    
}
