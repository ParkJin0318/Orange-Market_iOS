//
//  CategoryEntity.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/27.
//

import Foundation
import RealmSwift

class CategoryEntity: Object, Codable {
    @objc dynamic var idx: Int
    @objc dynamic var name: String
}
