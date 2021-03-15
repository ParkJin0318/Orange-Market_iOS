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
        $0.cornerRadius = 8
    }
    
    private lazy var viewNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    func setupNode(product: ProductData) {
        self.titleNode.attributedText = product.title.toAttributed(color: .black, ofSize: 17)
        self.locationNode.attributedText = product.location.toAttributed(color: .gray, ofSize: 14)
        self.priceNode.attributedText = product.price.toBoldAttributed(color: .black, ofSize: 15)
        
        if (!product.imageList.isEmpty) {
            self.imageNode.url = URL(string: HOST + "images/" + product.imageList.first!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let borderLayout = self.borderLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 10, bottom: 0, right: 10),
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
            spacing: 3,
            justifyContent: .start,
            alignItems: .start,
            children: [titleNode, locationNode, priceNode]
        )
    }
}
