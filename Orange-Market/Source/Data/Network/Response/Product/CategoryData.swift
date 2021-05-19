//
//  ProductCategoryData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import Foundation

struct ProductCategoryData: Codable {
    let idx: Int
    let name: String
}

extension ProductCategoryData {
    
    func toModel() -> ProductCategory {
        return ProductCategory(
            idx: self.idx,
            name: self.name,
            isSelected: true
        )
    }
}
