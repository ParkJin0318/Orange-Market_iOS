//
//  LocalPostListSection.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/28.
//

import RxDataSources_Texture

enum LocalPostListSection {
    case localPost(localPosts: [LocalPostListSectionItem])
}

extension LocalPostListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .localPost:
                return "product"
        }
    }
    
    var items: [LocalPostListSectionItem] {
        switch self {
            case .localPost(let localPosts):
                return localPosts
        }
    }
    
    init(original: LocalPostListSection, items: [LocalPostListSectionItem]) {
        switch original {
            case .localPost:
                self = .localPost(localPosts: items)
        }
    }
}

enum LocalPostListSectionItem {
    case localPost(LocalPost)
}

extension LocalPostListSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .localPost(let post):
                return post.toString()
        }
    }
}

extension LocalPostListSectionItem: Equatable {
    
    static func == (lhs: LocalPostListSectionItem, rhs: LocalPostListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
