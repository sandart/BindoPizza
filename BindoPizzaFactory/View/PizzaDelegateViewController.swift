//
//  PizzaDelegateViewController.swift
//  BindoPizzaFactory
//
//  Created by 沙畫 on 2020/2/19.
//  Copyright © 2020 art. All rights reserved.
//

import UIKit

class PizzaDelegateViewController: UIViewController, StoryboardInitializable {

    
    @IBOutlet weak var tableView: UITableView!
    
    var chefs: [Int] = []
    var delagateAction: ((_ chef: Int)-> Void)?

    var viewModel: PizzaDelegateViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PizzaDelegateViewModel(items: chefs)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonOnClick(_ sender: Any) {
        if viewModel.selectedChef >= 0 {
            delagateAction?(viewModel.selectedChef)
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

extension PizzaDelegateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chefs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: PizzaDelegateCell.self)
        cell.accessoryType = .none
        cell.textLabel?.text = "Chef \(viewModel.chefs[indexPath.row])"
        return cell
    }
    
}

extension PizzaDelegateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        viewModel.selectedChef = viewModel.chefs[indexPath.row]
    }
}
