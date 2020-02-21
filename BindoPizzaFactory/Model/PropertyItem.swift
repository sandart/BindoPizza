//
//  PropertyItem.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation

class PropertyItem {
    var title: String
    var weight: String?
    var isSelected: Bool = false
    var isMore: Bool = false
    
    init?(dictionary: AnyDict) {
        guard let _title = dictionary["name"] as? String  else{
            return nil
        }
        title = _title
        if let _weight = dictionary["weight"] as? String{
            weight = _weight
        }

    }
}
