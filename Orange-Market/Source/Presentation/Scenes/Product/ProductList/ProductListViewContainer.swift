//
//  ProductListViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit

class ProductListViewContainer: ASDisplayNode {
    
    lazy var tableNode = ASTableNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: tableNode)
    }
}
