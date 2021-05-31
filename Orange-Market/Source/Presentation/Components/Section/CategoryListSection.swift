//
//  CategoryListSection.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/31.
//

import RxDataSources_Texture

enum CategoryListSection {
    case category(categories: [CategoryListSectionItem])
}

extension CategoryListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .category:
                return "category"
        }
    }
    
    var items: [CategoryListSectionItem] {
        switch self {
            case .category(let items):
                return items
        }
    }
    
    init(original: CategoryListSection, items: [CategoryListSectionItem]) {
        switch original {
            case .category:
                self = .category(categories: items)
        }
    }
}

enum CategoryListSectionItem {
    case category(ProductCategory)
}

extension CategoryListSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .category(let category):
                return category.toString()
        }
    }
}

extension CategoryListSectionItem: Equatable {
    
    static func == (lhs: CategoryListSectionItem, rhs: CategoryListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
