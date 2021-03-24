//
//  ProductDetailContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import AsyncDisplayKit

class ProductDetailContainerNode: ASDisplayNode {
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 60, height: 60)
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
    }
    
    lazy var collectionNode = ASCollectionNode(collectionViewLayout: flowLayout).then {
        $0.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        $0.style.preferredSize = CGSize(width: width, height: 300)
        $0.alwaysBounceHorizontal = true
        $0.backgroundColor = .systemBackground
    }
    
    lazy var profileNode = ProfileNode()
    
    lazy var contentNode = ProductContentNode()
    
    lazy var productBottomNode = ProductBottomNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 80)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let productDetailLayout = self.productDetailLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .spaceBetween,
            alignItems: .start,
            children: [productDetailLayout, productBottomNode]
        )
    }
    
    private func productDetailLayoutSpec() -> ASLayoutSpec {
        let profileInsetLayout = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 20, bottom: 10, right: 20),
            child: profileNode
        )
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                collectionNode,
                profileInsetLayout,
                contentNode
            ]
        )
    }
}
