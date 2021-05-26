//
//  CommentInputNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/21.
//

import AsyncDisplayKit

class CommentInputNode: ASDisplayNode {
    
    lazy var commentField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.borderStyle = .none
    }
    
    private lazy var commentNode = commentField.toNode().then {
        $0.style.flexGrow = 1
    }
    
    lazy var sendNode = ASImageNode().then {
        $0.image = UIImage(systemName: "arrow.forward.circle.fill")
        $0.style.preferredSize = .init(width: 20, height: 20)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [commentNode, sendNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 10, bottom: 0, right: 10),
            child: layout
        )
    }
}
