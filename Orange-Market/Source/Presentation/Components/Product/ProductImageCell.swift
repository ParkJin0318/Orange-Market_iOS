//
//  ProductImageCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import AsyncDisplayKit

class ProductImageCell: ASCellNode {
    
    lazy var imageNode = ASNetworkImageNode().then {
        $0.style.preferredSize = CGSize(width: 60, height: 60)
        $0.cornerRadius = 5
    }
    
    init(image: String) {
        super.init()
        self.automaticallyManagesSubnodes = true
        
        if (!image.isEmpty) {
            self.imageNode.url = image.toUrl()
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }
}
