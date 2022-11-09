//
//  SummaryVC.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit

class SummaryVC: UIViewController {

    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var menuItemsForSelection:[MenuItem] = []
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var eachTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    

 
    
    @IBAction func tapBack(_ sender: Any) {
        print("tapped back")
        dismiss(animated: true)
    }
    

}

extension SummaryVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsForSelection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let menuItem = menuItemsForSelection[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as? SummaryCell else {
            return UITableViewCell() }
        cell.configureCell(name: menuItem.name!, price: menuItem.price ?? 0, quantity: Int(menuItem.quantity))
        
        return cell
    }
    
  
    
    
}
