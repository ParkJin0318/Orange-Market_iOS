//
//  ProductDetailContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import AsyncDisplayKit

class ProductDetailContainer: ASDisplayNode {
    
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
    
    lazy var profileImageNode = ASNetworkImageNode().then {
        $0.style.preferredSize = CGSize(width: 30, height: 30)
        $0.cornerRadius = 30 / 2
    }
    
    lazy var nameNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var locationNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    private lazy var viewNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [collectionNode, profileLayout, viewNode]
        )
    }
    
    private func profileLayoutSpec() -> ASLayoutSpec {
        let userInfoLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 3,
            justifyContent: .start,
            alignItems: .start,
            children: [nameNode, locationNode]
        )
        
        let profileLayout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .start,
            alignItems: .center,
            children: [profileImageNode, userInfoLayout]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 5, left: 20, bottom: 5, right: 20),
            child: profileLayout
        )
    }
}
