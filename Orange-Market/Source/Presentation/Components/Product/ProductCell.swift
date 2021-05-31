//
//  ProductCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit

class ProductCell: ASCellNode {
    
    lazy var imageNode = ASNetworkImageNode().then {
        $0.style.preferredSize = CGSize(width: 90, height: 90)
        $0.cornerRadius = 5
    }
    
    lazy var titleNode = ASTextNode()
    
    lazy var locationNode = ASTextNode()
    
    lazy var priceNode = ASTextNode()
    
    lazy var likeNode = ASButtonNode().then {
        $0.imageNode.image = UIImage(systemName: "heart")
        $0.imageNode.style.preferredSize = CGSize(width: 13, height: 13)
        $0.alpha = 0.7
    }
    
    init(product: Product) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        
        self.titleNode.attributedText = product.title.toAttributed(color: .label, ofSize: 17)
        self.locationNode.attributedText = product.city.toAttributed(color: .gray, ofSize: 14)
        self.priceNode.attributedText = "\(product.price)원".toBoldAttributed(color: .label, ofSize: 15)
        self.likeNode.titleNode.attributedText = "\(product.likeUsers.count)".toAttributed(color: .label, ofSize: 13)
        
        if (product.likeUsers.count < 1) {
            self.likeNode.isHidden = true
        }
        if (!product.images.isEmpty) {
            self.imageNode.url = product.images.first?.toUrl()
        }
    }
}

extension ProductCell {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let borderLayout = self.borderLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: borderLayout
        )
    }
    
    private func borderLayoutSpec() -> ASLayoutSpec {
        let productLayout = self.productLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .end,
            children: [productLayout, likeNode]
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
