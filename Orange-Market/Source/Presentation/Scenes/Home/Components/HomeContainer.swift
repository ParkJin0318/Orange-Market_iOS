//
//  HomeContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit

class HomeContainer: ASDisplayNode {
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 60, height: 60)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 10
    }
    
    lazy var collectionNode = ASCollectionNode(collectionViewLayout: flowLayout).then {
        $0.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        $0.alwaysBounceVertical = true
        $0.backgroundColor = .systemBackground
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }
}
