//
//  AddOrderViewModel.swift
//  CofeeOrdering
//
//  Created by Juan Bonforti on 11/01/2021.
//

import Foundation

struct AddOrderViewModel {
    
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String?
    
    var type: [String] {
        return CoffeeTypesModel.allCases.map { $0.rawValue.capitalized }
    }
    var size: [String] {
        return CoffeeSizeModel.allCases.map { $0.rawValue.capitalized }
    }
    
}
