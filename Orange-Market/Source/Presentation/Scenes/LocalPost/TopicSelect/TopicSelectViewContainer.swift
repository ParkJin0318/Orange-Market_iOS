//
//  TopicSelectViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit

class TopicSelectViewContainer: ASDisplayNode {
    
    lazy var titleNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 10
    }
    
    lazy var collectionNode = ASCollectionNode(collectionViewLayout: flowLayout).then {
        $0.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        $0.style.flexGrow = 1
        $0.alwaysBounceVertical = true
        $0.backgroundColor = .systemBackground
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let containerLayout = self.containerLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 20, bottom: 0, right: 20),
            child: containerLayout
        )
    }
    
    private func containerLayoutSpec() -> ASLayoutSpec {
        let titleLayout = ASInsetLayoutSpec(
            insets: .init(top: 20, left: 10, bottom: 20, right: 10),
            child: titleNode
        )
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [titleLayout, collectionNode]
        )
    }
}
