//
//  PizzaCell.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/18.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit

typealias PizzaBlock = ((_ pizza: Pizza)->Void)

class PizzaCell: UITableViewCell {

    var pizza: Pizza!
    var editClosure: PizzaBlock?
    var delegateClosure: PizzaBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         pizzaName.layer.cornerRadius = 3
         pizzaName.clipsToBounds = true
        // Initialization code
    }
    @IBOutlet weak var pizzaName: UILabel!
    
    @IBAction func editOnClick(_ sender: Any) {
        editClosure?(pizza)
    }
    
    @IBAction func delegateOnClick(_ sender: Any) {
        delegateClosure?(pizza)
    }
    
    
    func config(pizza: Pizza, editAction: PizzaBlock?, delegateAction: PizzaBlock?){
        self.pizza = pizza
        pizzaName.text = pizza.identifier
        
        editClosure = editAction
        delegateClosure = delegateAction
    }

}
