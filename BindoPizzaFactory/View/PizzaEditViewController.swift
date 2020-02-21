//
//  PizzaEditViewController.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit

class PizzaEditViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var editClosure:((_ text: String) -> Void)?
    var viewModel: PizzaEditViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PizzaEditViewModel()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonOnClick(_ sender: Any) {
        
       let result = viewModel.propertyGroup.reduce("") { (result, group) -> String in
          let title =  group.items
                .filter{$0.isSelected}
                .reduce("") { (result, item) -> String in
                  return  result + "[\(item.title)]."
                }
           return result + title
        }
        
//        let editState = viewModel.propertyGroup.reduce(false) { (result, group) -> Bool in
//             let value = result || (group.items.filter{$0.isSelected}.count > 0)
//            return value
//        }
        
        if result.count > 0 {
            editClosure?(result)
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PizzaEditViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
           return CGSize(width: collectionView.bounds.width, height: 30)
        }

        let properties = viewModel.propertyGroup[indexPath.section]
        var item = properties.items[indexPath.item]
        
        if !viewModel.isShowToppings && (indexPath.row == (properties.items.count >> 1)) {
            let moreItem = PropertyItem(dictionary: ["name":" + MORE TOPPINGS"])
             moreItem?.isMore = true
            item = moreItem!
        }

        let itemWidth = item.title.width(font: UIFont.systemFont(ofSize: 14),
                        constrained: CGSize(width: collectionView.frame.width, height: 40))
        

        return CGSize(width: itemWidth + 30, height: 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}



extension PizzaEditViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.propertyGroup.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }

        let count = viewModel.isShowToppings
            ? viewModel.propertyGroup[section].items.count
            : (viewModel.propertyGroup[section].items.count >> 1) + 1
        return  count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let propretyReusableView = collectionView.dequeueSupplementaryView(ofType: PropretyReusableView.self, kind: UICollectionView.elementKindSectionHeader, at: indexPath)
        propretyReusableView.titleLabel.text = viewModel.propertyGroup[indexPath.section].title
        return propretyReusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let group = viewModel.propertyGroup[indexPath.section]
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueCell(ofType: SizeCell.self, at: indexPath)
            cell.config(items: group.items, segmentAction: { [weak self](index) in
                guard let `self` = self else {return}
                let propertyGroup = self.viewModel.propertyGroup[indexPath.section]
                
                let item = propertyGroup.items[index]
                if !item.isSelected {
                    let items = propertyGroup.items.map { (item) -> PropertyItem in
                          let _item = item
                          _item.isSelected = false
                          return _item
                    }
                    propertyGroup.items = items
                }
                
                item.isSelected = !item.isSelected
                propertyGroup.items[index] = item

                self.viewModel.propertyGroup[indexPath.section] = propertyGroup
                self.collectionView.reloadItems(at: [indexPath])
            })
            return cell
        }
        else {
            let cell = collectionView.dequeueCell(ofType: ToppingsCell.self, at: indexPath)
            if viewModel.isShowToppings {
                cell.config(item: group.items[indexPath.row])
            }
            else{
                if (indexPath.row == (group.items.count >> 1)){
                    let moreItem = PropertyItem(dictionary: ["name":" + MORE TOPPINGS"])
                     moreItem?.isMore = true
                    cell.config(item: moreItem!)
                }
                else{
                    cell.config(item: group.items[indexPath.row])
                }
            }

            return cell;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {return}
        
        let group = self.viewModel.propertyGroup[indexPath.section]
        if !viewModel.isShowToppings && (indexPath.row == (group.items.count >> 1)){
            viewModel.isShowToppings = true
        }
        else{
            let item = group.items[indexPath.item]
            item.isSelected = !item.isSelected
            group.items[indexPath.item] = item
            self.viewModel.propertyGroup[indexPath.section] = group
        }

        self.collectionView.reloadItems(at: [indexPath])
    }
    
 
}
