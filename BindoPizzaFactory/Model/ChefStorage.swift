//
//  ChefStorage.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/20.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation
import SQLite

struct ChefTable {
        static let shared = ChefTable()
        
        private let chefTable = Table("BD_Chef_Info")
        private let id = Expression<Int>("ci_id")
        private let number = Expression<Int>("ci_no")
        private let speed = Expression<Int>("ci_speed")
        private let isCooking = Expression<Bool>("ci_cooking_state")

        private var documentPath: String {
            return NSSearchPathForDirectoriesInDomains( .documentDirectory,
                                                        .userDomainMask,
                                                        true)[0]
        }
        
        private var db: Connection?

        private init() {
            print(documentPath)
            do {
                db = try Connection("\(documentPath)/db.sqlite3")
                try db?.run(chefTable.create(temporary: false,
                                     ifNotExists: true,
                                    withoutRowid: false,
                                           block: { (builder) in
                        builder.column(id, primaryKey: true)
                        builder.column(number, unique: true)
                        builder.column(speed)
                        builder.column(isCooking)
                }))
            } catch  {
                
            }
            
        }
    
    
    func insert(chef: Chef) -> Bool {
        do {
            let insert =  chefTable.insert(number <- chef.number,
                                         speed <- chef.speed,
                                     isCooking <- chef.isCooking)
            let rowid = try db?.run(insert) ?? 0
            return rowid > 0
        }
        catch  {
             return false
        }

    }
    
    func update(chef: Chef) -> Bool {
        do {
            let alice = chefTable.filter(number == chef.number)
            let updateSQL = alice.update(isCooking <- chef.isCooking)
            let rowid = try db?.run(updateSQL) ?? 0
            return rowid > 0
        }
        catch {
            return false
        }
    }
    
    func find(by chefNumber: Int) -> Chef? {
        do {
            let selectSQL =  chefTable.filter(number == chefNumber)
            if let item = try db!.pluck(selectSQL) {
                let _number = item[number]
                let _speed = item[speed]
                let iconName = "chef_\(_number)"
                let chef = Chef(iconName: iconName, number: _number, speed: _speed, cooking: item[isCooking])
                return chef
            }
        } catch  {
            return nil
        }
        return nil
    }
    
    func findAll() -> [Chef] {
        do {
            var chefs: [Chef] = []
            for item in try db!.prepare(chefTable) {
                let _number = item[number]
                let _speed = item[speed]
                let iconName = "chef_\(_number + 1)"
                let chef = Chef(iconName: iconName, number: _number, speed: _speed, cooking: item[isCooking])
                chefs.append(chef)
            }
            return chefs
        } catch  {
            return []
        }
    }
    
    
}
