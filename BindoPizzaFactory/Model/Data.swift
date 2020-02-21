//
//  Data.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/18.
//  Copyright © 2020 art. All rights reserved.
//
import UIKit
import Foundation

struct Data {
  static let chefCount: Int = 7
  static let pizzaCount: Int = 1000
  static let pizza10: Int = 10
  static let pizza100: Int = 100
  static let tasteMenu = [
            [ "title": "SIZE",
              "items": [
                    ["name": "SMALL", "weight": "320g"],
                    ["name": "MEDIUM", "weight": "530g"],
                    ["name": "LARGE", "weight": "860g"]
                ]
            ],
            [ "title": "TOPPINGS",
              "items": [
                ["name":"ROAST BEEF"],
                ["name":"BELL PEPPERS"],
                ["name":"MUSHROOMS"],
                ["name":"ONIONS"],
                ["name":"TOMATOES"],
                ["name":"MARINARA"],
                ["name":"CHEESE"],
                ["name":"DURIAN"]
                ]
        ]
    ]
}

let pizzaColors = [
    UIColor(red: 48/255.0, green: 30/255.0, blue: 130/255.0, alpha: 1.0),
    UIColor(red: 175/255.0, green: 20/255.0, blue: 4/255.0, alpha: 1.0),
    UIColor(red: 3/255.0, green: 11/255.0, blue: 51/255.0, alpha: 1.0),
    UIColor(red: 1/255.0, green: 80/255.0, blue: 46/255.0, alpha: 1.0),
    UIColor(red: 48/255.0, green: 30/255.0, blue: 130/255.0, alpha: 1.0),
    UIColor(red: 10/255.0, green: 50/255.0, blue: 149/255.0, alpha: 1.0),
    UIColor(red: 2/255.0, green: 26/255.0, blue: 62/255.0, alpha: 1.0),
]
let pizzaBGColors = [
    UIColor(red: 227/255.0, green: 222/255.0, blue: 255/255.0, alpha: 1.0),
    UIColor(red: 255/255.0, green: 230/255.0, blue: 223/255.0, alpha: 1.0),
    UIColor(red: 254/255.0, green: 238/255.0, blue: 164/255.0, alpha: 1.0),
    UIColor(red: 222/255.0, green: 253/255.0, blue: 235/255.0, alpha: 1.0),
    UIColor(red: 227/255.0, green: 222/255.0, blue: 255/255.0, alpha: 1.0),
    UIColor(red: 214/255.0, green: 229/255.0, blue: 255/255.0, alpha: 1.0),
    UIColor(red: 254/255.0, green: 238/255.0, blue: 164/255.0, alpha: 1.0),
]

let BorderLineColor = UIColor(red: 180/255.0, green: 186/255.0, blue: 197/255.0, alpha: 1.0).cgColor
let GaryColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
let YellowColor = UIColor(red: 254/255.0, green: 220/255.0, blue: 125/255.0, alpha: 1.0)

let ScreenWidth = UIScreen.main.bounds.width;
let ScreenHeight = UIScreen.main.bounds.height;


