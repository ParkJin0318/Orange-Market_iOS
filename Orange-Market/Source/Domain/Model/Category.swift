//
//  Category.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import Foundation

struct Category {
    let idx: Int
    let name: String
    var isSelected: Bool
}

extension Category {
    func toEntity() -> CategoryEntity {
        return CategoryEntity(
            idx: self.idx,
            name: self.name,
            isSelected: self.isSelected
        )
    }
}
