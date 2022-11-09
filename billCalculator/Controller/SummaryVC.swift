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
    
    
    @IBOutlet weak var totalWithDrinks: UILabel!
    
    @IBOutlet weak var totalWithoutDrinks: UILabel!
    @IBOutlet weak var eachTotalWithoutDrink: UILabel!
    var menuItemsForSelection:[MenuItemSection] = []
 
    var totalNumberOfPeople:Int = 0
    var hasServiceCharge = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let basePrice:Double = Double(totalWithoutDrinks.text!)! / Double(totalNumberOfPeople)
    
        var drinkItems = self.menuItemsForSelection.first { $0.type == "drink" }
                if drinkItems != nil {
                    var yPos = 680
            for item in drinkItems!.menuItems!{
                 
                let labelNum = UILabel()
                var price = Double(item.price!)
                if(self.hasServiceCharge){
                    price = price * 1.1
                }
                let combinedPrice = String(format: "%.3f", basePrice + Double(price))
               
                       let num1Nnum2 = "With " + item.name! + ":£" +  combinedPrice
                labelNum.font = UIFont.systemFont(ofSize: 17,weight: .bold)
                       labelNum.text = num1Nnum2
                       labelNum.textAlignment = .center
                       labelNum.frame = CGRect( x:95, y:yPos, width:250, height: 80)
                       yPos += 25
                       self.view.addSubview(labelNum)

                  
            }
        }
    }

 
    
    @IBAction func tapBack(_ sender: Any) {
        print("tapped back")
        dismiss(animated: true)
    }
    

}

extension SummaryVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let menuItem = menuItemsForSelection[indexPath.section].menuItems![indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as? SummaryCell else {
            return UITableViewCell() }
         cell.configureCell(name: menuItem.name!, price: menuItem.price ?? 0, quantity: Int(menuItem.quantity))
        
        return cell
    }
    
  
    
    
}
