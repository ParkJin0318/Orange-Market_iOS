//
//  ProductCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit

class ProductCell: ASCellNode {
    
    private lazy var titleNode = ASTextNode()
    
    private lazy var locationNode = ASTextNode()
    
    private lazy var priceNode = ASTextNode()
    
    private lazy var imageNode = ASNetworkImageNode().then {
        $0.style.preferredSize = CGSize(width: 100, height: 100)
        $0.cornerRadius = 5
    }
    
    private lazy var viewNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    func setupNode(product: Product) {
        self.titleNode.attributedText = product.title.toAttributed(color: .black, ofSize: 17)
        self.locationNode.attributedText = product.city.toAttributed(color: .gray, ofSize: 14)
        self.priceNode.attributedText = "\(product.price)원".toBoldAttributed(color: .black, ofSize: 15)
        
        if (!product.image.isEmpty) {
            self.imageNode.url = product.image.toUrl()
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let borderLayout = self.borderLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 5, left: 10, bottom: 0, right: 10),
            child: borderLayout
        )
    }
    
    private func borderLayoutSpec() -> ASLayoutSpec {
        let productLayout = self.productLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 8,
            justifyContent: .start,
            alignItems: .start,
            children: [productLayout, viewNode]
        )
    }
    
    private func productLayoutSpec() -> ASLayoutSpec {
        let infoLayout = self.infoLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [imageNode, infoLayout]
        )
    }
    
    private func infoLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .start,
            children: [titleNode, locationNode, priceNode]
        )
    }
}
