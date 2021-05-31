//
//  LocalCommentListSection.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/28.
//

import RxDataSources_Texture

enum LocalCommentListSection {
    case localComment(localComments: [LocalCommentListSectionItem])
}

extension LocalCommentListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .localComment:
                return "topic"
        }
    }
    
    var items: [LocalCommentListSectionItem] {
        switch self {
            case .localComment(let localTopics):
                return localTopics
        }
    }
    
    init(original: LocalCommentListSection, items: [LocalCommentListSectionItem]) {
        switch original {
            case .localComment:
                self = .localComment(localComments: items)
        }
    }
}

enum LocalCommentListSectionItem {
    case localPost(LocalPost)
    case localComment(LocalComment)
}

extension LocalCommentListSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .localPost(let post):
                return post.toString()
                
            case .localComment(let comment):
                return comment.toString()
        }
    }
}

extension LocalCommentListSectionItem: Equatable {
    
    static func == (lhs: LocalCommentListSectionItem, rhs: LocalCommentListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
