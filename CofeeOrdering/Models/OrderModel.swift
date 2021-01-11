//
//  OrderModel.swift
//  CofeeOrdering
//
//  Created by Juan Bonforti on 11/01/2021.
//

import Foundation

struct OrderModel: Codable {
    let name: String
    let email: String
    let type: CoffeeTypesModel
    let size: CoffeeSizeModel
}

extension OrderModel {
    
    static var all: Resource<[OrderModel]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("URL is incorrect") }
        
        return Resource<[OrderModel]>(url: url)
    }()
    
    static func create(viewModel: AddOrderViewModel) -> Resource<OrderModel?> {
        
        let order = OrderModel(viewModel)
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("URL is incorrect") }
        
        guard let data = try? JSONEncoder().encode(order) else { fatalError("Error encoding order") }
        
        var resource = Resource<OrderModel?>(url: url)
        resource.method = HttpMethod.post
        resource.body = data
        
        return resource
    }
}

extension OrderModel {
    
    init?(_ viewModel: AddOrderViewModel) {
        
        guard let name = viewModel.name,
              let email = viewModel.email,
              let selectedType = CoffeeTypesModel(rawValue: viewModel.selectedType!.lowercased()),
              let selectedSize = CoffeeSizeModel(rawValue: viewModel.selectedSize!.lowercased()) else { return nil }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
        
    }
}
