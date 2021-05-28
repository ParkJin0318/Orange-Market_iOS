//
//  LocalTopicListSection.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/28.
//

import RxDataSources_Texture

enum LocalTopicListSection {
    case localTopic(localTopics: [LocalTopicListSectionItem])
}

extension LocalTopicListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .localTopic:
                return "topic"
        }
    }
    
    var items: [LocalTopicListSectionItem] {
        switch self {
            case .localTopic(let localTopics):
                return localTopics
        }
    }
    
    init(original: LocalTopicListSection, items: [LocalTopicListSectionItem]) {
        switch original {
            case .localTopic:
                self = .localTopic(localTopics: items)
        }
    }
}

enum LocalTopicListSectionItem {
    case localTopic(LocalTopic)
}

extension LocalTopicListSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
            case .localTopic(let topic):
                return topic.toString()
        }
    }
}

extension LocalTopicListSectionItem: Equatable {
    
    static func == (lhs: LocalTopicListSectionItem, rhs: LocalTopicListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
