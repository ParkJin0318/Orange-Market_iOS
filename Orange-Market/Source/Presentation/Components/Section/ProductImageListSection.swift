//
//  ProductImageListSection.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/28.
//

import RxDataSources_Texture

enum ProductImageListSection {
    case image(images: [ProductImageListSectionItem])
}

extension ProductImageListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .image:
                return "image"
        }
    }
    
    var items: [ProductImageListSectionItem] {
        switch self {
            case .image(let items):
                return items
        }
    }
    
    init(original: ProductImageListSection, items: [ProductImageListSectionItem]) {
        switch original {
            case .image:
                self = .image(images: items)
        }
    }
}

enum ProductImageListSectionItem {
    case image(String)
}

extension ProductImageListSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .image(let image):
                return image
        }
    }
}

extension ProductImageListSectionItem: Equatable {
    
    static func == (lhs: ProductImageListSectionItem, rhs: ProductImageListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

