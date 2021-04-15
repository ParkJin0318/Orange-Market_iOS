//
//  ProductDetailContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import AsyncDisplayKit

class ProductDetailViewContainer: ASDisplayNode {
    
    lazy var productScrollNode = ProductScrollNode().then {
        $0.style.preferredSize = CGSize(width: width, height: height - 80)
    }
    
    lazy var productBottomNode = ProductBottomNode().then {
        $0.style.layoutPosition = CGPoint(x: 0, y: height / 1.3)
        $0.style.preferredSize = CGSize(width: width, height: 80)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.automaticallyRelayoutOnSafeAreaChanges = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASAbsoluteLayoutSpec(
            sizing: .default,
            children: [productScrollNode, productBottomNode]
        )
    }
}
