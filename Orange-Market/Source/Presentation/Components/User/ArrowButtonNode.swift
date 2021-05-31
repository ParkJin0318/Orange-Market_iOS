//
//  ArrowButtonNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/28.
//

import AsyncDisplayKit

class ArrowButtonNode: ASButtonNode {
    
    lazy var nameNode = ASTextNode()
    
    lazy var iconNode = ASImageNode().then {
        $0.image = UIImage(systemName: "arrow.right")
    }
}

extension ArrowButtonNode {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let arrowMenuLayout = self.arrowMenuLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 10, bottom: 0, right: 10),
            child: arrowMenuLayout
        )
    }
    
    private func arrowMenuLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [nameNode, iconNode]
        )
    }
}
