//
//  CategoryData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import Foundation

struct CategoryData: Codable {
    let idx: Int
    let name: String
}

extension CategoryData {
    
    func toModel() -> Category {
        return Category(
            idx: self.idx,
            name: self.name,
            isSelected: false
        )
    }
}
