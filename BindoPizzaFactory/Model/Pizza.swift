//
//  Pizza.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/18.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation

enum PizzaState {
    case begin
    case end
    case none
}

struct Pizza {
    var identifier: String
    var state: PizzaState
    
}


