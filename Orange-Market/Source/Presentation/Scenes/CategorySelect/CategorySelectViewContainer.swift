//
//  CategoryViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import AsyncDisplayKit
import BEMCheckBox

class CategorySelectViewContainer: ASDisplayNode {
    
    lazy var titleNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var descriptionNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 10
    }
    
    lazy var collectionNode = ASCollectionNode(collectionViewLayout: flowLayout).then {
        $0.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        $0.style.preferredSize = CGSize(width: width, height: height / 1.5)
        $0.alwaysBounceVertical = true
        $0.backgroundColor = .systemBackground
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let categoryLayout = self.categoryLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 20, bottom: 0, right: 20),
            child: categoryLayout
        )
    }
    
    private func categoryLayoutSpec() -> ASLayoutSpec {
        
        let descriptionLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .start,
            alignItems: .center,
            children: [titleNode, descriptionNode]
        )
        
        let descriptionInsetLayout = ASInsetLayoutSpec(
            insets: .init(top: 30, left: 0, bottom: 30, right: 20),
            child: descriptionLayout
        )
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [descriptionInsetLayout, collectionNode]
        )
    }
}
