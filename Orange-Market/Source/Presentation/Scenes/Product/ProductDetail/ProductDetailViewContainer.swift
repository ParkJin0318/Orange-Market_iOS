//
//  ProductDetailViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import AsyncDisplayKit

class ProductDetailViewContainer: ASDisplayNode {
    
    lazy var productScrollNode = ProductScrollNode().then {
        $0.style.flexGrow = 1
    }
    
    lazy var productBottomNode = ProductBottomNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let bottomInset: UIEdgeInsets = .init(
            top: .infinity,
            left: 0.0,
            bottom: 0.0,
            right: 0.0
        )
        
        let bottomLayout = ASInsetLayoutSpec(
            insets: bottomInset,
            child: productBottomNode
        )
        
        let overLayout = ASOverlayLayoutSpec(
            child: productScrollNode,
            overlay: bottomLayout
        )
        
        return ASInsetLayoutSpec(insets: .zero, child: overLayout)
    }
}
