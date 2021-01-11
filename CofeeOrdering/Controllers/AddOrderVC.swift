//
//  AddOrderVC.swift
//  CofeeOrdering
//
//  Created by Juan Bonforti on 11/01/2021.
//

import Foundation
import UIKit

protocol AddOrderVCDelegate {
    func addOrderVCDidSave(order: OrderModel, controller: UIViewController)
    func addOrderVCDidCancel(controller: UIViewController)
}

class AddOrderVC: UIViewController {
    
    // MARK: - IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Vars
    private var viewModel = AddOrderViewModel()
    private var coffeeSizeSegmentedControle = UISegmentedControl()
    var delegate: AddOrderVCDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
    }
    
    // MARK: - IBActions
    @IBAction func cancelOrderAction(_ sender: Any) {
        delegate?.addOrderVCDidCancel(controller: self)
    }
    
    @IBAction func performOrder(_ sender: Any) {
        let name = nameTextField.text
        let email = emailTextField.text
        
        let selectedSize = coffeeSizeSegmentedControle.titleForSegment(at: coffeeSizeSegmentedControle.selectedSegmentIndex)
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffee!")
        }
        
        viewModel.name = name
        viewModel.email = email
        viewModel.selectedSize = selectedSize
        viewModel.selectedType = viewModel.type[indexPath.row]
        
        Webservice().load(resource: OrderModel.create(viewModel: viewModel)) { result in
            
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addOrderVCDidSave(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

// MARK: - Extensions
extension AddOrderVC {
    
    private func setupUI() {
        coffeeSizeSegmentedControle = UISegmentedControl(items: viewModel.size)
        coffeeSizeSegmentedControle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coffeeSizeSegmentedControle)
        
        coffeeSizeSegmentedControle.topAnchor.constraint(equalTo: tableView.bottomAnchor,constant: 16).isActive = true
        coffeeSizeSegmentedControle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}


// UITableViewDelegate, UITableViewDataSource
extension AddOrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.viewModel.type[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

