//
//  MenuItemSection.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 9/11/2022.
//

import UIKit

class MenuItemSection {
    var type:String?
    var menuItems:[MenuItem]?
    
    init(type: String, menuItems: [MenuItem]) {
        self.type = type
        self.menuItems = menuItems
    }
}
