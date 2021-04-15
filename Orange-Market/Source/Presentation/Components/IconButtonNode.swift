//
//  BuyNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/15.
//

import AsyncDisplayKit

class IconButtonNode: ASButtonNode {
    
    lazy var iconNode = ASImageNode().then {
        $0.style.preferredSize = CGSize(width: 50, height: 50)
    }
    
    lazy var textNode = ASTextNode()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .center,
            children: [iconNode, textNode]
        )
    }
}
