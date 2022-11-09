//
//  EachGroupVC.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import UIKit

class EachGroupVC: UIViewController {
    
    
    @IBOutlet weak var totalNumberOfPeople: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total: UILabel!
    
    
    @IBOutlet weak var totalForEach: UILabel!
    
    var currentRestaurant:Restaurant!
    
    var hasServiceCharge = false
    
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
    
    
    @IBAction func numberOfPeopleSliderChanged(_ sender: UISlider) {
        totalNumberOfPeople.text = String(format: "%.0f", sender.value)
        updateTotalAndEachView()
    }
    
    
    @IBAction func didTapSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            hasServiceCharge=true
            updateTotalAndEachView()
        }else{
            hasServiceCharge=false
            updateTotalAndEachView()
        }
    }
    
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func calculateTotal() -> Double {
        var calculatedTotal:Double = 0
        for menuItem in menuItemsForSelection {
            let quantity = Int(menuItem.quantity)
            let price = Int(menuItem.price ?? 0)
            calculatedTotal += Double(quantity * price)
        }
        
        if(self.hasServiceCharge){
            calculatedTotal =  calculatedTotal*1.1
        }
        return calculatedTotal
    }
    
    private func updateTotalAndEachView() -> Void {
       let calculatedTotal = calculateTotal()
        var each = calculatedTotal / Double(totalNumberOfPeople.text!)!
        let eachStr  =  String(format: "%.2f", each)
        total.text = "Total: £\(String(format: "%.2f", calculatedTotal))"
     
        totalForEach.text = "Each person should pay: £\(eachStr)"
    }
    
    
    @IBAction func didTapShowSummary(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
        
        var menuItemsForSelection_copy = self.menuItemsForSelection
        
         menuItemsForSelection_copy = self.menuItemsForSelection.filter {
            $0.quantity > 0
        }
        
        vc.menuItemsForSelection = menuItemsForSelection_copy
        vc.total.text = self.total.text
        vc.eachTotal.text = self.totalForEach.text
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
        cell.configureCell(name: menuItem.name!,price:menuItem.price ?? 0, quantity:0, quantityChangeHandler:quantityChangeHandler())
        
        
        print("current cell value ====>", cell.quantity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
  
    private func quantityChangeHandler()->ButtonHandler{
        return { [unowned self] cell in
            var calculatedTotal:Double = 0
            guard let row = self.tableView.indexPath(for: cell)?.row else { return}
            menuItemsForSelection[row].quantity = Int32(cell.quantity.text!)!
            calculatedTotal = self.calculateTotal()
//            for menuItem in menuItemsForSelection {
//                let quantity = Int(menuItem.quantity)
//                let price = Int(menuItem.price ?? 0)
//                calculatedTotal += Double(quantity * price)
//            }
//
//            if(self.hasServiceCharge){
//                calculatedTotal =  calculatedTotal*1.1
//            }
            updateTotalAndEachView()
       
        }
         
    }
    
    
    
}
