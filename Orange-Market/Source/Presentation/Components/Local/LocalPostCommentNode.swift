//
//  LocalPostCommentNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/21.
//

import AsyncDisplayKit

class LocalPostCommentNode: ASDisplayNode {
    
    lazy var commentInputNode = CommentInputNode().then {
        $0.style.preferredSize = .init(width: width, height: 40)
        $0.backgroundColor = .lightGray()
        $0.cornerRadius = 15
    }
    
    lazy var backgroundNode = ASDisplayNode().then {
        $0.style.preferredSize = .init(width: width, height: 60)
        $0.backgroundColor = .systemBackground
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension LocalPostCommentNode {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let commentLayout = self.commentLayoutSpec()
        
        return commentLayout
    }
    
    func commentLayoutSpec() -> ASLayoutSpec {
        let layout = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 20, bottom: 10, right: 20),
            child: commentInputNode
        )
        
        return ASOverlayLayoutSpec(
            child: backgroundNode,
            overlay: layout
        )
    }
}
