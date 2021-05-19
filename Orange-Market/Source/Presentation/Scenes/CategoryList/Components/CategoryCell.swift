//
//  CategoryCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/29.
//

import AsyncDisplayKit

class CategoryCell: ASCellNode {
    
    lazy var nameNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
 
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
    }
    
    func setupNode(category: ProductCategory) {
        nameNode.attributedText = category.name.toAttributed(color: .label, ofSize: 14)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .init(top: 15, left: 15, bottom: 15, right: 15),
            child: nameNode
        )
    }
}

