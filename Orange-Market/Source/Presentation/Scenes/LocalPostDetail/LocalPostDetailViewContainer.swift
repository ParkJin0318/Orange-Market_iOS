//
//  LocalPostDetailViewContainer.swift
//  Orange-Market
//
//  Created by 박진동 on 2021/05/20.
//

import AsyncDisplayKit
import RxSwift

class LocalPostDetailViewContainer: ASDisplayNode {
    
    var keyboardVisibleHeight: CGFloat = 0.0
    
    lazy var tableNode = ASTableNode().then {
        $0.style.flexGrow = 1
        $0.allowsSelectionDuringEditing = false
    }
    
    lazy var localPostCommentNode = LocalPostCommentNode().then {
        $0.backgroundColor = .lightGray()
        $0.cornerRadius = 10
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension LocalPostDetailViewContainer {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let commentLayout = ASInsetLayoutSpec(
            insets: .init(top: 0.0, left: 0.0, bottom: self.keyboardVisibleHeight, right: 0.0),
            child: localPostCommentNode
        )
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: [tableNode, commentLayout]
        )
    }
}
