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
    
    func toString() -> String {
        return "\(idx) \(name) \(isSelected)"
    }
}

extension Array where Element == LocalTopic {
    
    func contains(_ array: [LocalTopic]) -> Bool {
        return self.map { $0.toString() }.elementsEqual(array.map { $0.toString() })
    }
}
