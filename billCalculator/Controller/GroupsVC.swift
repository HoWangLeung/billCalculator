//
//  GroupsVCViewController.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit

class GroupsVC: UIViewController {
    
    
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentRestaurant:Restaurant!
    
     var groups:[Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
    

}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let group1 = Group()
        group1.name = "Default Group 1"
        let group2 = Group()
        group2.name = "Default Group 2"
        groups.append(group1)
        groups.append(group2)
     let group = groups[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupCell else {
            return UITableViewCell() }
        cell.configureCell(groupName: group.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EachGroupVC") as! EachGroupVC
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
        vc.groupName.text = self.groups[indexPath.row].name
        vc.currentRestaurant = self.currentRestaurant
       // vc.resetQuantity()
//        vc.total.text = ""
//        vc.totalForEach.text = ""
        
    }
    
    
}
