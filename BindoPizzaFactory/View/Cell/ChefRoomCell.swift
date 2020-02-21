//
//  ChefRoomCell.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/18.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit

typealias ChefBlock = ((_ pizzaRow: Int)->Void)

class ChefRoomCell: UICollectionViewCell {
    
    @IBOutlet weak var headerView: UIView!{
        didSet{
            headerView.layer.borderWidth = 0.5
            headerView.layer.borderColor = BorderLineColor
        }
    }
    @IBOutlet weak var infoView: UIView!{
        didSet{
            infoView.layer.borderWidth = 0.5
            infoView.layer.borderColor = BorderLineColor
        }
    }
    
    @IBOutlet weak var chefIcon: UIImageView!
    @IBOutlet weak var cookingState: UISwitch!
    @IBOutlet weak var chefNumber: UILabel!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var pizzaList: UITableView!
    
    var chef: Chef!
    var editClosure: ChefBlock?
    var delegateClosure: ChefBlock?
    var cookClosure: ((_ state: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.5
        layer.borderColor = BorderLineColor
    }
    
    @IBAction func cookSwitch(_ sender: UISwitch) {
        cookClosure?(sender.isOn)
    }
    
    
    func config(chef: Chef,
                editAction: ChefBlock?,
                delegateAction: ChefBlock?,
                cookAction:((_ state: Bool)->Void)?){
        self.chef = chef
        chefIcon.image = UIImage(named: chef.icon)
        cookingState.isOn = chef.isCooking
        chefNumber.text = "Pizza Chef \(chef.number)"
        productCount.text = "\(chef.tasks.count)"
        speed.text = "Speed: \(chef.number + 1) second per pizza"
        
        editClosure = editAction
        delegateClosure = delegateAction
        cookClosure = cookAction
        
        pizzaList.reloadData()
    }
    
}

extension ChefRoomCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.chef.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: PizzaCell.self)
        cell.pizzaName.textColor = pizzaColors[chef.number]
        cell.pizzaName.backgroundColor = pizzaBGColors[chef.number]
        cell.config(pizza: chef.tasks[indexPath.row],
                    editAction: {(pizza: Pizza) in
                        self.editClosure?(indexPath.row)
        },
                    delegateAction: {(pizza: Pizza) in
                        self.delegateClosure?(indexPath.row)
        })
        
        return cell
    }
    
    
}
