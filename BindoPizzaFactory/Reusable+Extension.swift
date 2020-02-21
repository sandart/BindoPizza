//
//  Reusable+Extension.swift
//  RTXD
//
//  Created by 沙畫 on 2017/11/12.
//  Copyright © 2017年 puffant. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}

extension UIViewController: Reusable {}

extension UICollectionReusableView: Reusable {}


extension UITableView {
    func dequeueCell<T>(ofType type: T.Type) -> T {
        return  dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }

    func dequeueCell<T>(ofType type: T.Type, indexPath: IndexPath) -> T {
        return  dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func dequeueHeaderFooterView<T>(ofType type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
    }
}

extension UICollectionView {
    func dequeueCell<T>(ofType type: T.Type, at indexPath: IndexPath) -> T {
        return  dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func dequeueSupplementaryView<T>(ofType type: T.Type, kind: String, at indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
