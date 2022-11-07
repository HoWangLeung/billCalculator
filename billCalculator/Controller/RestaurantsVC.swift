//
//  ViewController.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit
import CoreData
let appDelegate = UIApplication.shared.delegate as? AppDelegate
class RestaurantsVC: UIViewController {
    
    var restaurants:[Restaurant] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addRestaurantBtn: UIButton!
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
        print("in view will appear")
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    func fetchCoreDataObjects(){
        self.fetch{(complete) in
            if complete{
                 print("get it in view will appear")
           
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    
}

extension RestaurantsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let restaurant = restaurants[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantCell else {
            return UITableViewCell() }
        cell.configureCell(restaurantName: restaurant.restaurantName!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE"){
            (rowAction,indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    
    
}



extension RestaurantsVC {
    
    func removeGoal(atIndexPath indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
        managedContext.delete(restaurants[indexPath.row])
        do{
            try managedContext.save()
            print("removed successfully")
        }catch{
            debugPrint("COULD NOT REMOVE: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion:(_ complete: Bool)->()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<Restaurant>(entityName: "Restaurant")
   
        
        do{
            restaurants = try managedContext.fetch(fetchRequest)
            print("successfully fetched data")
            print(restaurants.count)
            completion(true)
        }catch{
            debugPrint("ERROR: \(error.localizedDescription)")
        }
        
    }
}
