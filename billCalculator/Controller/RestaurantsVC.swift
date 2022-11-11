//
//  ViewController.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit
import CoreData
import CoreLocation
//let appDelegate = UIApplication.shared.delegate as? AppDelegate
class RestaurantsVC: UIViewController {
    
    var restaurants:[Restaurant] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addRestaurantBtn: UIButton!
    
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //presentingViewController?.viewWillDisappear(true)
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
    
    
    @IBAction func handleAddBtnClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddEditRestaurantVC") as! AddEditRestaurantVC
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
        
        vc.currentRestaurant = DataManager.shared.restaurant(restaurantName: "This is a Default")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // presentingViewController?.viewWillAppear(true)
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
        cell.configureCell(restaurantName: restaurant.restaurantName!,restaurantAddress: restaurant.address!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GroupsVC") as! GroupsVC
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
        vc.restaurantName.text = self.restaurants[indexPath.row].restaurantName
        vc.currentRestaurant = self.restaurants[indexPath.row]
    }
    //For Edit and Delete Starts
    
    private func deleteAction(rowIndexPathAt indexPath: IndexPath) ->
    UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (_,_,_) in
            DataManager.shared.removeRestaurant(restaurants: self.restaurants, indexPath: indexPath)
            self.fetchCoreDataObjects()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return action
    }
    private func editAction (rowIndexPathAt indexPath: IndexPath) ->
    UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit"){ (_,_,_) in
            print("pressed Edit in swipe")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditRestaurantVC") as! AddEditRestaurantVC
            vc.modalPresentationStyle = .fullScreen
            vc.isEditMode = true
            vc.currentRestaurant = self.restaurants[indexPath.row]
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



extension RestaurantsVC {
    
//    func removeGoal(atIndexPath indexPath: IndexPath){
//        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
//        managedContext.delete(restaurants[indexPath.row])
//        do{
//            try managedContext.save()
//            print("removed successfully")
//        }catch{
//            debugPrint("COULD NOT REMOVE: \(error.localizedDescription)")
//        }
//    }
    
    func fetch(completion:(_ complete: Bool)->()){
        
        let fetchRequest = NSFetchRequest<Restaurant>(entityName: "Restaurant")
   
         
        
        do{
            restaurants = DataManager.shared.getRestaurants()
            print("successfully fetched data")
          
            
            print("successfully fetched data end...........")
            
            completion(true)
        }catch{
            debugPrint("ERROR: \(error.localizedDescription)")
        }
        
    }
}

extension RestaurantsVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = manager.location?.coordinate
        let latitude = coordinate?.latitude ?? 0
        let longtitude = coordinate?.longitude ?? 0
        print("latitude = ",coordinate?.latitude ?? 0)
        print("longtitude = ",coordinate?.longitude ?? 0)
      
        let myLocation = CLLocation(latitude: latitude, longitude: longtitude)
//53.472125997452366, -2.2495993441244666
        //My buddy's location
        let myBuddysLocation = CLLocation(latitude: 53.478645469683315, longitude: -2.2394721613121646)
        
        //Measuring my distance to my buddy's (in km)
        let distance = myLocation.distance(from: myBuddysLocation) / 1000

        //Display the result in km
        print(String(format: "The distance to my buddy is %.01fkm", distance))
        
        print("distance = ",distance)
        locationManager.stopUpdatingLocation()
        
        let address = "45-47 Faulkner St, Manchester M1 4EE"

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                return
            }
            
            // Use your location
            print("place marks", placemarks)
            print("location from string = ", location)
            
      
        
        }
        
        
    }
}
