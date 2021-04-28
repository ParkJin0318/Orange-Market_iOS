//
//  CategoryEntity.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/27.
//

import Foundation
import RealmSwift

class CategoryEntity: Object {
    @objc dynamic var idx: Int = -1
    @objc dynamic var name: String?
    @objc dynamic var isSelected: Bool = false
    
    convenience init(idx: Int, name: String, isSelected: Bool) {
        self.init()
        self.idx = idx
        self.name = name
        self.isSelected = isSelected
    }
}

extension CategoryEntity {
    
    func toModel() -> Category {
        return Category(
            idx: self.idx,
            name: self.name ?? "",
            isSelected: self.isSelected
        )
    }
}
