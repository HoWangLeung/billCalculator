//
//  ItemTypeButtonExt.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 9/11/2022.
//

import UIKit
extension UIButton {
    
    func setSelectedColour(){
        self.backgroundColor = .systemMint
    }
    
    
    func setDeselectedColour(){
        self.backgroundColor = .systemMint.withAlphaComponent(0.6)
    }
}
