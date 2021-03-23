//
//  ProductContentNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/22.
//

import AsyncDisplayKit

class ProductContentNode: ASDisplayNode {
    
    lazy var titleNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var dateNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var contentsNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                titleNode,
                dateNode,
                contentsNode
            ]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 20, bottom: 0, right: 20),
            child: contentLayout
        )
    }
}
