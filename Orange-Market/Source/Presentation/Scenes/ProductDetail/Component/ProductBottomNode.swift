//
//  ProductBottomNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/22.
//

import AsyncDisplayKit

class ProductBottomNode: ASDisplayNode {
    
    lazy var likeNode = ASButtonNode().then {
        $0.imageNode.image = UIImage(systemName: "heart")
    }
    
    lazy var priceNode = ASTextNode()
    
    lazy var buyNode = ASButtonNode().then {
        $0.backgroundColor = .primaryColor()
        $0.style.preferredSize = CGSize(width: width / 3, height: 40)
        $0.cornerRadius = 5
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        priceNode.style.flexGrow = 1
        
        let productBottomLayout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [likeNode, priceNode, buyNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 20, bottom: 30, right: 20),
            child: productBottomLayout
        )
    }
}
