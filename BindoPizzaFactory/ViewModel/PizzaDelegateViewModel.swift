//
//  PizzaDelegateViewModel.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation

class PizzaDelegateViewModel {
    
    var chefs: [Int] = []
    var selectedChef: Int = -1
    
    init(items: [Int]) {
       chefs = items
    }
}
