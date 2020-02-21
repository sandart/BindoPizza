//
//  SizeCell.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit

class SizeCell: UICollectionViewCell {
   
    
    @IBOutlet var sizeButtons: [UIButton]!
    
    @IBAction func sizeButtonOnClick(_ sender: UIButton) {
        segmentClosure?(sender.tag-1)
    }
        
    @IBOutlet weak var segmentBottomView: UIView!{
        didSet{
        segmentBottomView.layer.cornerRadius = 30 * 0.5
        segmentBottomView.clipsToBounds = true
        }
    }
    var segmentClosure:((_ index: Int)->Void)?

       
    func config(items: [PropertyItem], segmentAction: ((_ index: Int)->Void)?){
        setButtonStyle(items: items)
        segmentClosure = segmentAction
    }
    
    
    func setButtonStyle(items: [PropertyItem]) {
        for (index, item) in items.enumerated() {
             let button = sizeButtons[index]
            
             let text = item.title + " " + (item.weight ?? "")
             let attributeText = NSMutableAttributedString(string: text)

            //设置部分粗体
            attributeText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                                        range: NSMakeRange(0, item.title.count))
            attributeText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
                                        range: NSMakeRange(item.title.count + 1, item.weight!.count))
            //设置前景颜色
            attributeText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                        range: NSMakeRange(0, item.title.count))
            attributeText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray],
                                        range: NSMakeRange(item.title.count + 1, item.weight!.count))
            button.titleLabel?.adjustsFontSizeToFitWidth = true;
            button.setAttributedTitle(attributeText, for: .normal)
            button.backgroundColor = item.isSelected ? YellowColor : GaryColor
        }
    }
    
}
