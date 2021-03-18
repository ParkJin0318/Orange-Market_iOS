//
//  ProductImageCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import AsyncDisplayKit

class ProductImageCell: ASCellNode {
    
    lazy var imageNode = ASNetworkImageNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    func setupNode(url: String) {
        if (!url.isEmpty) {
            print(url)
            self.imageNode.url = URL(string: HOST + "images/" + url)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }
}
