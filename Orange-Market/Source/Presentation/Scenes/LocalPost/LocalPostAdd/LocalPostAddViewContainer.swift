//
//  LocalPostAddViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit

class LocalPostAddViewContainer: ASDisplayNode {
    
    lazy var topicSelectNode = ArrowButtonNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var separatorNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    lazy var contentNode = ASEditableTextNode().then {
        $0.typingAttributes = [
            NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.label
        ]
        $0.textContainerInset = .init(top: 5, left: 10, bottom: 5, right: 10)
        $0.style.preferredSize = .init(width: width, height: 300)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let topicSelectLayout = ASInsetLayoutSpec(
            insets: .init(top: 20, left: 0, bottom: 10, right: 0),
            child: topicSelectNode
        )
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                topicSelectLayout,
                separatorNode,
                contentNode
            ]
        )
    }
}
