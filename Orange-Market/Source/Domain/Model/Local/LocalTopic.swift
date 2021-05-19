//
//  LocalTopic.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation

struct LocalTopic {
    let idx: Int
    let name: String
    var isSelected: Bool
}

extension LocalTopic {
    
    func toEntity() -> LocalTopicEntity {
        return LocalTopicEntity(
            idx: self.idx,
            name: self.name,
            isSelected: self.isSelected
        )
    }
}
