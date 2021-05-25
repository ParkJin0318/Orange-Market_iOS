//
//  ProductCategory.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import Foundation

struct ProductCategory {
    let idx: Int
    let name: String
    var isSelected: Bool
}

extension ProductCategory {
    
    func toEntity() -> ProductCategoryEntity {
        return ProductCategoryEntity(
            idx: self.idx,
            name: self.name,
            isSelected: self.isSelected
        )
    }
    
    func toString() -> String {
        return "\(idx) \(name) \(isSelected)"
    }
}

extension Array where Element == ProductCategory {
    
    func contains(_ array: [ProductCategory]) -> Bool {
        return self.map { $0.toString() }.elementsEqual(array.map { $0.toString() })
    }
}
