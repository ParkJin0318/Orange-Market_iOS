//
//  LocalPostCommentNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/21.
//

import AsyncDisplayKit

class LocalPostCommentNode: ASDisplayNode {
    
    lazy var commentInputNode = CommentInputNode().then {
        $0.backgroundColor = .lightGray()
        $0.cornerRadius = 15
    }
    
    lazy var backgroundNode = ASDisplayNode().then {
        $0.style.preferredSize = .init(width: width, height: tabBarHeight)
        $0.backgroundColor = .systemBackground
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .systemBackground
    }
}

extension LocalPostCommentNode {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let commentLayout = self.commentLayoutSpec()
        
        return ASOverlayLayoutSpec(
            child: backgroundNode,
            overlay: commentLayout
        )
    }
    
    func commentLayoutSpec() -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 20, bottom: tabBarHeight - 50, right: 20),
            child: commentInputNode
        )
    }
}
