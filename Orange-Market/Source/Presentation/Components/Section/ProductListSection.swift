//
//  ProductListSection.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/28.
//

import RxDataSources_Texture

enum ProductListSection {
    case product(products: [ProductListSectionItem])
}

extension ProductListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .product:
                return "product"
        }
    }
    
    var items: [ProductListSectionItem] {
        switch self {
            case .product(let items):
                return items
        }
    }
    
    init(original: ProductListSection, items: [ProductListSectionItem]) {
        switch original {
            case .product:
                self = .product(products: items)
        }
    }
}

enum ProductListSectionItem {
    case product(Product)
}

extension ProductListSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .product(let product):
                return product.toString()
        }
    }
}

extension ProductListSectionItem: Equatable {
    
    static func == (lhs: ProductListSectionItem, rhs: ProductListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
