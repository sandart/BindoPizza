//
//  PizzaEditViewModel.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation

class PizzaEditViewModel {
    
    var propertyGroup: [PropertyGroup] = []
    var isShowToppings = false
    
    init() {
        propertyGroup = Data.tasteMenu.compactMap{PropertyGroup(dictionary: $0)}

    }
    

    
    
}
