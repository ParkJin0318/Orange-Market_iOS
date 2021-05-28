//
//  LocalTopicCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/24.
//

import AsyncDisplayKit

class LocalTopicCell: ASCellNode {
    
    lazy var topicNode = ASButtonNode().then {
        $0.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        $0.borderWidth = 1
        $0.borderColor = UIColor.lightGray.cgColor
        $0.cornerRadius = 4
        $0.backgroundColor = .systemBackground
    }
    
    init(topic: LocalTopic) {
        super.init()
        self.automaticallyManagesSubnodes = true
        
        if (topic.idx == 0) {
            self.topicNode.imageNode.image = UIImage(systemName: "slider.horizontal.3")
        } else {
            self.topicNode.titleNode.attributedText = topic.name.toAttributed(color: .label, ofSize: 12)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .zero,
            child: topicNode
        )
    }
}
