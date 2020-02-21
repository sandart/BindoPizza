//
//  Property.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import Foundation

typealias AnyDict = [String: Any]

class PropertyGroup {
    var title: String
    var items: [PropertyItem]
    init?(dictionary: AnyDict) {
        guard let _title = dictionary["title"] as? String ,
            let _items = dictionary["items"] as? [AnyDict] else{
                return nil
        }
        title = _title
        items = _items.compactMap{PropertyItem(dictionary: $0)}
    }
}

