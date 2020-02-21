//
//  PizzaFactoryServer.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/20.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation
import SQLite

class PizzaFactoryService {
    
    
    func fetchChefs() -> [Chef] {
       var chefs = ChefTable.shared.findAll()
       if chefs.count > 0 { return chefs }
        //创建Chef
        for i in 0..<Data.chefCount {
            let speed = i + 1
            let chef = Chef(iconName:"chef_\(speed)", number: i, speed: speed, cooking: true)
            chefs.append(chef)
            _ = ChefTable.shared.insert(chef: chef)
        }
        return chefs
    }
    
    func isDispatchTask() -> Bool {
       let count = PizzaTable.shared.count()
       return count > 0
    }
    
    func fetchHistoryTasks(for chef: Chef) -> [Pizza] {
        let taskItems = PizzaTable.shared.findAll(chefNumber: chef.number)
        return taskItems
    }
    
    func createTask(pizzas: [Pizza], for chefNumber: Int)  {
        for pizza in pizzas {
          _ =  PizzaTable.shared.insert(pizza: pizza, chefNumber: chefNumber)
        }
    }
    
    func deleteTask(pizza: Pizza, for chefNumber: Int)  {
        _ = PizzaTable.shared.delete(idString: pizza.identifier, chefNumber: chefNumber)

    }
    
}

