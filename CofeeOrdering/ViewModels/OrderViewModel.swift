//
//  OrderViewModel.swift
//  CofeeOrdering
//
//  Created by Juan Bonforti on 11/01/2021.
//

import Foundation
import UIKit

// List of Orders to view on Table
class OrderListViewModel {
    
    var ordersViewModel: [OrderViewModel]
    
    init() {
        self.ordersViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.ordersViewModel[index]
    }
}


// One order
struct OrderViewModel {
    let order: OrderModel
    
    var name: String {
        return self.order.name
    }
    var email: String {
        return self.order.email
    }
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    var size: String {
        return self.order.size.rawValue.capitalized
    }
    
}
