//
//  LocalPostDetailViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit
import RxSwift

class LocalPostDetailViewContainer: ASDisplayNode {
    
    lazy var localPostContentNode = LocalPostContentNode()
    
    lazy var localPostCommentNode = LocalPostCommentNode().then {
        $0.backgroundColor = .lightGray()
        $0.cornerRadius = 10
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.automaticallyRelayoutOnSafeAreaChanges = true
    }
}

extension LocalPostDetailViewContainer {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        localPostCommentNode.style.layoutPosition = CGPoint(x: 0, y: height / 1.3)
        
        return ASAbsoluteLayoutSpec(
            sizing: .default,
            children: [localPostContentNode, localPostCommentNode]
        )
    }
}
