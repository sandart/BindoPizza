//
//  PizzaStorage.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/20.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation
import SQLite

struct PizzaTable {
        static let shared = PizzaTable()
        
        private let pizzaTable = Table("BD_Pizza_Info")
        private let id = Expression<Int>("pi_id")
        private let identifier = Expression<String>("pi_idtf")
        private let state = Expression<Int>("pi_state")
        private let chefNumber = Expression<Int>("pi_chef_no")

        private var documentPath: String {
            return NSSearchPathForDirectoriesInDomains( .documentDirectory,
                                                        .userDomainMask,
                                                        true)[0]
        }
        
        private var db: Connection?

        private init() {
            do {
                db = try Connection("\(documentPath)/db.sqlite3")
                try db?.run(pizzaTable.create(temporary: false,
                                     ifNotExists: true,
                                    withoutRowid: false,
                                           block: { (builder) in
                        builder.column(id, primaryKey: true)
                        builder.column(identifier, unique: true)
                        builder.column(state)
                        builder.column(chefNumber)
                }))
            } catch  {

            }

        }
    
    
    func insert(pizza: Pizza, chefNumber: Int) -> Bool {
        do {
            let _state = pizza.state == .end ? 1 : 0;
            let insert =  pizzaTable.insert(identifier <- pizza.identifier,
                                         state <- _state,
                                         self.chefNumber <- chefNumber)
            let rowid = try db?.run(insert) ?? 0
            return rowid > 0
        }
        catch  {
             return false
        }

    }

    func update(pizza: Pizza, chefNumber: Int) -> Bool {
        do {
            let alice = pizzaTable.filter((identifier == pizza.identifier))
            let _state = pizza.state == .end ? 1 : 0;
            let updateSQL = alice.update(state <- _state, self.chefNumber <- chefNumber)
            let rowid = try db?.run(updateSQL) ?? 0
            return rowid > 0
        }
        catch {
            return false
        }
    }

    func find(by idString: String) -> Pizza? {
        do {
            let selectSQL =  pizzaTable.filter(identifier == idString)
            if let item = try db!.pluck(selectSQL) {
                let _identifier = item[identifier]
                let _state = item[state] == 1 ? PizzaState.end : PizzaState.none
                let pizza = Pizza.init(identifier: _identifier, state: _state)
                return pizza
            }
        } catch  {
            return nil
        }
        return nil
    }

    func findAll(chefNumber: Int) -> [Pizza] {
        do {
            let selectSQL =  pizzaTable.filter(self.chefNumber == chefNumber)
            var pizzas: [Pizza] = []
            for item in try db!.prepare(selectSQL) {
                let _identifier = item[identifier]
                let _state = item[state] == 1 ? PizzaState.end : PizzaState.none
                let pizza = Pizza.init(identifier: _identifier, state: _state)
                pizzas.append(pizza)
            }
            return pizzas
        } catch  {
            return []
        }
    }
    
    func delete(idString: String, chefNumber: Int) -> Bool {
        let alice = pizzaTable.filter(identifier == idString && self.chefNumber == chefNumber)
        do {
            if try db!.run(alice.delete())  > 0 {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    func count() -> Int  {
        do {
            let count = try db?.scalar(pizzaTable.count)
            return count ?? 0
        }
        catch  {
           return 0
        }
    }

    
}

