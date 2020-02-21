//
//  PizzaFactoryViewModel.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/18.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation

class PizzaFactoryViewModel {
   
    var chefs: [Chef] = []
    var allCooking: Bool = true
    
    private var bukets: [[String]] = []
    private var buketCapacities: [Int] = []

    private var service = PizzaFactoryService()
    init(count: Int) {
 
        let items = service.fetchChefs()
        bukets = Array<[String]>.init(repeating: [], count: items.count)
        buketCapacities = Array<Int>.init(repeating: 0, count: items.count)
        chefs.append(contentsOf: items)
        allCooking = items.reduce(false) { (result, chef) -> Bool in
            return result || chef.isCooking
        }
        if service.isDispatchTask() {
            for item in items {
              let historyTasks = service.fetchHistoryTasks(for: item)
              item.excute(tasks: historyTasks)
            }
        }
        else{
             dispatchTasks(taskCount: Data.pizzaCount)
        }

    }
    
    private func dispatchTasks(taskCount:Int) {
        
        //分配pizza任务
        let start = buketCapacities.reduce(0, {$0 + $1})
        let end = start + taskCount
        for i in start..<end {
            let idx = i % chefs.count
            let pizzaString = String(format: "PIZZA_%04d", i + 1)
            bukets[idx].append(pizzaString)
            buketCapacities[idx] = bukets[idx].count
        }
        
        //创建pizza任务
        for (index, buket) in bukets.enumerated() {
            let chef = chefs[index]
            let pizzas = buket.map ({ Pizza(identifier: $0, state: .none)})
            service.createTask(pizzas: pizzas, for: index)
            chef.excute(tasks: pizzas)
            chefs[index] = chef
        }
        resetBukets()
    }
    
    private func resetBukets(){
         bukets = Array<[String]>.init(repeating: [], count: chefs.count)
    }
    
    
    func addNewTask(taskCount:Int, finished:(()->Void)?) {
        dispatchTasks(taskCount: taskCount)
        finished?()
    }
    
    func updatePizza(pizzaRow: Int, chefNumber: Int, finished:((_ result: Bool)->Void)?) {
        let chef = chefs[chefNumber];
        let result = chef.updatePizza(pizzaRow: pizzaRow)
        finished?(result)
    }
    
    func movePizza(form oldChefNumber: Int,
                              pizzaRow: Int,
                        to newChefNumber: Int,
                              finished:((_ result: Bool)->Void)? ) {
        
        let oldChef = chefs[oldChefNumber];
        let newChef = chefs[newChefNumber];
        if let pizza = oldChef.movePizza(pizzaRow: pizzaRow) {
            newChef.addNewPizza(pizza: pizza)
            service.createTask(pizzas: [pizza], for: newChef.number)
            chefs[newChefNumber] = newChef
            finished?(true)
        }
        else{
             finished?(false)
        }

        
    }
    
    func switchChef(state: Bool, at: Int, action:(() -> Void)?) {
        let chef = chefs[at];
        chef.isCooking = state
        chefs[at] = chef
        if chef.isCooking {
            chef.resumeTask(action: action)
        }
        else{
            chef.pauseTask(action: action)
        }
    }
    
    func switchAllChefs(state: Bool, action:@escaping () -> Void) {
        for i in 0..<chefs.count {
            let _chef = chefs[i]
            if _chef.isCooking != state {
                switchChef(state: state, at: i, action: nil)
            }
        }
        action()
    }
    
    
    
    
    
}
