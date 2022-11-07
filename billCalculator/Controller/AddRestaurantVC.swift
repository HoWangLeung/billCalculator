//
//  GroupsVC.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 7/11/2022.
//

import UIKit

class AddRestaurantVC: UIViewController {

    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var restaurantName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func confirmBtnWasPressed(_ sender: Any) {
        print("clicked")
        if restaurantName.text != "" {
            self.save{ (complete) in
                if complete {
                    print("dismissing")
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsVC") as! RestaurantsVC

                    let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)

                    navigationController.modalPresentationStyle = .fullScreen

                    present(navigationController, animated: true, completion: nil)
                }
                
            }
        }
 
    }
    

    func save(completion:(_ finished:Bool)->()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
        let restaurant = Restaurant(context: managedContext)
        restaurant.restaurantName =  restaurantName.text
        
        
        do{
            try managedContext.save()
            print("saved successfully")
            completion(true)
        }catch{
            debugPrint("ERROR: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
