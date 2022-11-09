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
    
    
    var currentRestaurant:Restaurant!
    
    var hasServiceCharge = false
    
    var menuItemsForSelection:[MenuItemSection] = []
    var currentRestaurantId = ""
    
    var totalWithoutDrinks:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.sectionHeaderTopPadding = 5
        //self.tableView = UITableView(frame: .zero, style: .grouped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("42 view will appear")
        let restaurant = self.currentRestaurant
        let menuItems = DataManager.shared.getMenuItemsByRestaurant(currentRestaurant: currentRestaurant)
        let menuItemsWithSections = getDataWithSections(menuItems: menuItems)
        self.menuItemsForSelection = menuItemsWithSections
        updateTotalAndEachView()
      
    }
    
    private func getDataWithSections(menuItems:[MenuItem]) -> [MenuItemSection] {
        var menuItemsWithSections:[MenuItemSection] = []
        var menuItemsFood = menuItems.filter{ $0.type == "food"}
        var menuItemsDrink = menuItems.filter{ $0.type == "drink"}
        menuItemsWithSections.append(MenuItemSection.init(type: "food", menuItems: menuItemsFood))
        menuItemsWithSections.append(MenuItemSection.init(type: "drink", menuItems: menuItemsDrink))
        return menuItemsWithSections
    }
    
    public func resetQuantity(){
        for menuItem in self.menuItemsForSelection {
           
            for item in menuItem.menuItems! {
                item.quantity = 0
            }
            
        }
      //  print("self.menuItemsForSelection",self.menuItemsForSelection)
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
        DataManager.shared.save()
        dismiss(animated: true)
    }
    
    private func calculateTotal() -> Double {
        var calculatedTotal:Double = 0
        var noDrinkTotal:Double = 0
        for menuItem in self.menuItemsForSelection {
           
            for item in menuItem.menuItems! {
                let quantity = Double(item.quantity)
                let price = Double(item.price ?? 0)
                calculatedTotal += Double(quantity) * price
            }
            
            if(menuItem.type == "food"){
                for item in menuItem.menuItems! {
                let quantity = Double(item.quantity)
                let price = Double(item.price ?? 0)
                noDrinkTotal += Double(quantity * price)
                }
            }
            
            
            
        }
         

        if(self.hasServiceCharge){
            calculatedTotal =  calculatedTotal*1.1
            noDrinkTotal = noDrinkTotal*1.1
        }
        self.totalWithoutDrinks = noDrinkTotal
        return calculatedTotal
    }

    private func updateTotalAndEachView() -> Void {
       let calculatedTotal = calculateTotal()
        var each = calculatedTotal / Double(totalNumberOfPeople.text!)!
        let eachStr  =  String(format: "%.3f", each)
        total.text = String(format: "%.3f", calculatedTotal)

        
    }
    
    
    @IBAction func didTapShowSummary(_ sender: Any) {
        DataManager.shared.save()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)

        var menuItemsForSelection_copy = self.menuItemsForSelection

        
        
        for menuItem in menuItemsForSelection_copy{
            menuItem.menuItems =  menuItem.menuItems!.filter{
                $0.quantity > 0
            }
        }
        
        var eachTotalWithoutDrinks = Double(self.totalWithoutDrinks)/Double(self.totalNumberOfPeople.text!)!
//String(format: "%.2f", calculatedTotal)        vc.menuItemsForSelection = menuItemsForSelection_copy
        vc.eachTotalWithoutDrink.text = String(format: "%.3f", eachTotalWithoutDrinks)
        vc.totalWithDrinks.text = self.total.text
        vc.totalWithoutDrinks.text = String(format: "%.3f", self.totalWithoutDrinks)
        vc.totalNumberOfPeople = Int(totalNumberOfPeople.text!)!
        vc.hasServiceCharge = self.hasServiceCharge
      
    }
    
    
    

    
    

}

extension EachGroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuItemsForSelection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemsForSelection[section].menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor =  .white
        
        let lbl = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width-15, height: 40))
       // lbl.backgroundColor = .lightGray.withAlphaComponent(0.3)
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
             lbl.text = self.menuItemsForSelection[section].type!.capitalized
        lbl.textColor = .systemMint
     
             view.addSubview(lbl)
             return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menuItem = self.menuItemsForSelection[indexPath.section].menuItems?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuSelectionCell") as? MenuSelectionCell else {
            return UITableViewCell() }
        cell.configureCell(name: menuItem!.name!,price:menuItem!.price ?? 0, quantity:Int(menuItem!.quantity), quantityChangeHandler:quantityChangeHandler())
        if(menuItem!.quantity>0){
            cell.backgroundColor = .systemMint
            cell.name.textColor = .white
            cell.quantity.textColor = .white
            cell.price.textColor = .white
            cell.priceLabel.textColor = .white
            cell.quantityLabel.textColor = .white
        }else{
            cell.backgroundColor = .white
            cell.name.textColor = .black
            cell.quantity.textColor = .black
            cell.price.textColor = .black
            cell.priceLabel.textColor = .black
            cell.quantityLabel.textColor = .black
            
        }
        
        
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

            guard let section = self.tableView.indexPath(for: cell)?.section else { return}
            guard let row = self.tableView.indexPath(for: cell)?.row else { return}
            
           
            let menuItem =  menuItemsForSelection[section]
            let quantity = Int32(cell.quantity.text!)!
            menuItem.menuItems![row].quantity = quantity
        
 
            updateTotalAndEachView()
            tableView.reloadData()
       
        }
         
    }
    
    
    
}
