//
//  Chef.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/18.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit


class Chef {
    
    var icon: String
    var number: Int
    var speed: Int
    var isCooking: Bool
    private(set) var tasks: [Pizza] = []
    private(set)  var finishCount: Int = 0

    private var _taskQueue: DispatchQueue
    private var pizzaItems: [String: Pizza] = [:]
    private var workItems: [String:DispatchWorkItem] = [:]
    
    private let chefTable: ChefTable = ChefTable.shared
    private let pizzaTable: PizzaTable = PizzaTable.shared
    
    init(iconName: String, number: Int, speed: Int, cooking: Bool) {
        icon = iconName;
        self.number = number;
        self.speed = speed;
        isCooking = cooking
        _taskQueue = DispatchQueue(label: "com.bindo.chef - \(number)", qos: DispatchQoS.userInitiated)
        if !isCooking {
          _taskQueue.suspend()
        }
    }
    
    
    func excute(tasks: [Pizza]) {
     
        self.tasks.append(contentsOf: tasks)
        
        let finishItems = tasks.filter{$0.state == .end}
        self.finishCount += finishItems.count
       
        let undoItems = tasks.filter{$0.state == .none}
        for item in undoItems {
           self.pizzaItems[item.identifier] = item
        }
        
        for item in undoItems {
            let workItem = DispatchWorkItem { [weak self] in
                guard let `self` = self else { return }
                guard  var pizzaItem = self.pizzaItems[item.identifier] else { return }
                pizzaItem.state = .begin
                self.pizzaItems[pizzaItem.identifier] = pizzaItem
                sleep(UInt32(self.speed))
                guard  var _pizzaItem = self.pizzaItems[item.identifier] else { return }
                _pizzaItem.state = .end
                self.pizzaItems[pizzaItem.identifier] = _pizzaItem
                _ = self.pizzaTable.update(pizza: _pizzaItem, chefNumber: self.number)
                self.finishCount += 1
            }
            self.workItems[item.identifier] = workItem
            _taskQueue.async(execute: workItem)
        }

    }
    
    func updatePizza(pizzaRow:Int) -> Bool {
        if tasks.count <= pizzaRow { return false }
        let pizza = tasks[pizzaRow]
        guard let pizzaItem = self.pizzaItems[pizza.identifier]  else {
            return false
        }
        return pizzaItem.state == .none
    }
    
    func movePizza(pizzaRow:Int) -> Pizza? {
        if tasks.count <= pizzaRow { return nil }
        let pizza = tasks[pizzaRow]
        guard let pizzaItem = self.pizzaItems[pizza.identifier],
              pizzaItem.state == .none else {
            return nil
        }

        if let workItem = self.workItems[pizzaItem.identifier] {
           workItem.cancel()
           self.pizzaItems.removeValue(forKey: pizzaItem.identifier)
           self.workItems.removeValue(forKey: pizzaItem.identifier)
           _ = self.pizzaTable.delete(idString: pizzaItem.identifier, chefNumber: number)
        }
        let pz = tasks.remove(at: pizzaRow)
        return pz
    }
    
    func addNewPizza(pizza: Pizza) {
        tasks.append(pizza)
        self.pizzaItems[pizza.identifier] = pizza
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let `self` = self else { return }
            guard  var pizzaItem = self.pizzaItems[pizza.identifier] else { return }
            pizzaItem.state = .begin
            self.pizzaItems[pizzaItem.identifier] = pizzaItem
            sleep(UInt32(self.speed))
            guard  var _pizzaItem = self.pizzaItems[pizza.identifier] else { return }
            _pizzaItem.state = .end
            self.pizzaItems[pizzaItem.identifier] = _pizzaItem
            _ = self.pizzaTable.update(pizza: _pizzaItem, chefNumber: self.number)
            self.finishCount += 1
        }
        
        self.workItems[pizza.identifier] = workItem
        _taskQueue.async(execute: workItem)
    }
    
    func pauseTask(action: (() -> Void)?)  {
        _taskQueue.suspend()
        _ = chefTable.update(chef: self)
        action?()
    }
    
    
    func resumeTask(action: (() -> Void)?)  {
        _taskQueue.resume()
        _ = chefTable.update(chef: self)
        action?()
    }
    
    
}
