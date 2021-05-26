//
//  LocalTopicData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation

struct LocalTopicData: Codable {
    let idx: Int
    let name: String
}

extension LocalTopicData {
    
    func toModel() -> LocalTopic {
        return LocalTopic(
            idx: self.idx,
            name: self.name,
            isSelected: true
        )
    }
}
