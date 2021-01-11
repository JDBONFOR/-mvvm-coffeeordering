//
//  OrdersTableVC.swift
//  CofeeOrdering
//
//  Created by Juan Bonforti on 11/01/2021.
//

import Foundation
import UIKit

class OrdersTableVC: UITableViewController, AddOrderVCDelegate {
    
    
    
    let viewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
}

// MARK: - Extensions
extension OrdersTableVC {
    
    func fetchData() {
        
        Webservice().load(resource: OrderModel.all) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.viewModel.ordersViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.viewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell
    }
}


extension OrdersTableVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController, let addOrderVC = navC.viewControllers.first as? AddOrderVC else { fatalError() }
        
        addOrderVC.delegate = self
        
    }
    
    func addOrderVCDidSave(order: OrderModel, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        viewModel.ordersViewModel.append(orderVM)
        tableView.insertRows(at: [IndexPath.init(row: viewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addOrderVCDidCancel(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
