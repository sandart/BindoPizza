//
//  ViewController.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/18.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit

import PKHUD

class ViewController: UIViewController {

    /**
     *pizz列表
     */
    @IBOutlet weak var pizzaFactoryView: UICollectionView!
    
    @IBOutlet weak var allSwitchView: UIView!{
        didSet{
            allSwitchView.layer.borderWidth = 0.5
            allSwitchView.layer.borderColor = BorderLineColor
        }
    }
    @IBOutlet weak var allSwitchWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var new100View: UIView!{
        didSet{
            new100View.layer.borderWidth = 0.5
            new100View.layer.borderColor = BorderLineColor
        }
    }
    
    @IBOutlet weak var new10View: UIView!{
        didSet{
            new10View.layer.borderWidth = 0.5
            new10View.layer.borderColor = BorderLineColor
        }
    }
    
    @IBOutlet weak var actionButtonsView: UIView!{
        didSet{
            actionButtonsView.layer.borderWidth = 0.5
            actionButtonsView.layer.borderColor = BorderLineColor
        }
    }
    
    @IBOutlet weak var summaryView: UIView!{
        didSet{
            summaryView.layer.borderWidth = 0.5
            summaryView.layer.borderColor = BorderLineColor
        }
    }
    
    private var _timer: DispatchSourceTimer!
    @IBOutlet var summarys: [UILabel]!
    @IBOutlet weak var allSwitch: UISwitch!
    
    var viewModel: PizzaFactoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = PizzaFactoryViewModel(count: Data.chefCount);
        
        _timer = DispatchSource.makeTimerSource(flags: .strict,
                                                queue: DispatchQueue.global())
        _timer.schedule(deadline: .now(), repeating: Double(1.0))
        _timer.setEventHandler {[weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                for (index, chef) in self.viewModel.chefs.enumerated(){
                    self.summarys[index].text = "\(chef.finishCount)";
                }
            }
        }
        _timer.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allSwitchWidthConstraint.constant = pizzaFactoryView.bounds.width / CGFloat(Data.chefCount);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allSwitch.isOn = viewModel.allCooking
    }

    
    @IBAction func allSwitch(_ sender: UISwitch) {
        viewModel.allCooking = sender.isOn
        viewModel.switchAllChefs(state: sender.isOn) {
            self.pizzaFactoryView.reloadData()
        }
    }
    
    @IBAction func add10OnClick(_ sender: Any) {
        viewModel.addNewTask(taskCount: Data.pizza10,
                             finished: { [weak self]() in
            guard let `self` = self else {return}
            self.pizzaFactoryView.reloadData()
        })
    }
    
    @IBAction func add100OnClick(_ sender: Any) {
        viewModel.addNewTask(taskCount: Data.pizza100,
                             finished: { [weak self]() in
            guard let `self` = self else {return}
            self.pizzaFactoryView.reloadData()
        })
    }
    
    func showPizzaMenu(chefNumber: Int, pizzaRow: Int) {
        let editViewController =  PizzaEditViewController.initFromStoryboard(name: "Main")
        editViewController.editClosure = {[weak self](text: String) in
            guard let `self` = self else { return }
            self.viewModel.updatePizza(pizzaRow: pizzaRow, chefNumber: chefNumber) { (result) in
                if result {
                    HUD.flash(.label(text), delay: 3.0)
                }
                else{
                    HUD.flash(.labeledError(title: nil,
                                         subtitle: "Sorry. Cannot modify a completed pizza"),
                              delay: 1.0)
                }
            }
        }
        self.present(editViewController, animated: true)
    }
    
    func showPizzaDelegate(chefNumber: Int, pizzaRow: Int) {
        let delagateViewController =  PizzaDelegateViewController.initFromStoryboard(name: "Main")
        delagateViewController.chefs = viewModel.chefs
            .filter({$0.number != chefNumber})
            .filter{$0.isCooking}
            .map{$0.number}
        delagateViewController.delagateAction = {[weak self](chef: Int) in
            
            guard let `self` = self else { return }
            self.viewModel.movePizza(form: chefNumber, pizzaRow: pizzaRow, to: chef, finished: {(result) in
                if result {
                    self.pizzaFactoryView.reloadData()
                    HUD.flash(.success, delay: 1.0)
                   print("chefNumber - \(chefNumber) - \(pizzaRow) delegate success")
                }
                else{
                    HUD.flash(.label("Sorry. Cannot modify a completed pizza"), delay: 1.0)
                   print("chefNumber - \(chefNumber) - \(pizzaRow) delegate error")
                }})
        }
        self.present(delagateViewController, animated: true)
    }
    
    
}



extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth:CGFloat = collectionView.bounds.width / CGFloat(Data.chefCount);
        let itemHeight:CGFloat = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }

}



extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Data.chefCount;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ChefRoomCell.self, at: indexPath)
        let chef = viewModel.chefs[indexPath.row]
        cell.config(chef: chef, editAction: {[weak self](pizzaRow: Int) in
            guard let `self` = self else{return}
            self.showPizzaMenu(chefNumber: indexPath.row, pizzaRow: pizzaRow)
        }, delegateAction: {[weak self](pizzaRow: Int) in
            guard let `self` = self else{return}
            self.showPizzaDelegate(chefNumber: indexPath.row, pizzaRow: pizzaRow)
        }, cookAction: { (state) in
            self.viewModel.switchChef(state: state,
                                         at: indexPath.row,
                                     action: {[weak self]() in
                guard let `self` = self else{return}
                self.pizzaFactoryView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
                let allCookingState = self.viewModel.chefs.filter{$0.isCooking}.count > 0
                if self.allSwitch.isOn != allCookingState {
                    self.allSwitch.isOn = allCookingState
                }
            })
        })
        return cell;
    }
    
 
}

