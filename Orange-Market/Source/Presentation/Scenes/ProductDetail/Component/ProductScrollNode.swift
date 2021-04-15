//
//  ProductScrollNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/28.
//

import AsyncDisplayKit

class ProductScrollNode: ASScrollNode {
    
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
    
    lazy var titleNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var dateNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var contentsNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.automaticallyManagesContentSize = true
        
        self.scrollableDirections = [.up, .down]
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        let contentLayout = self.contentLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                collectionNode,
                profileLayout,
                contentLayout
            ]
        )
    }
    
    private func profileLayoutSpec() -> ASLayoutSpec {

        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 20, bottom: 10, right: 20),
            child: profileNode
        )
    }
    
    private func contentLayoutSpec() -> ASLayoutSpec {
        let contentLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                titleNode,
                dateNode,
                contentsNode
            ]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 20, bottom: 0, right: 20),
            child: contentLayout
        )
    }
}
