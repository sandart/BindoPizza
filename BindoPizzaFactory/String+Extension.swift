//
//  String+Extension.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/21.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    func height(font: UIFont, constrained size: CGSize) -> CGFloat   {
        return self.size(font: font, constrained: size).height
    }
    
    func width(font: UIFont, constrained size: CGSize) -> CGFloat  {
        return self.size(font: font, constrained: size).width
    }
    
    func size(font: UIFont, constrained size: CGSize) -> CGSize  {
        
        var resultSize: CGSize = CGSize.zero
        
        if (self.count <= 0) {  return resultSize; }
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode =  NSLineBreakMode.byCharWrapping
        style.lineHeightMultiple = 1.2
        
        resultSize = self.boundingRect( with: size,
                                        options: [NSStringDrawingOptions.usesFontLeading, NSStringDrawingOptions.usesLineFragmentOrigin],
                                        attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style],
                                        context: nil).size
        resultSize = CGSize(width:floor(resultSize.width + 1), height:floor(resultSize.height + 1))
        
        return resultSize
    }
    
}
