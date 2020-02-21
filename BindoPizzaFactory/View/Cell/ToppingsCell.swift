//
//  ToppingsCell.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit

class ToppingsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        contentView.layer.cornerRadius = 15

    }
    func config(item: PropertyItem){
        textLabel.text = item.title
        if item.isMore {
           contentView.backgroundColor =  GaryColor
        }
        else{
            contentView.backgroundColor = item.isSelected ? YellowColor : GaryColor
        }

    }
    
}
