//
//  LocalPostListViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit
import RxSwift

class LocalPostListViewContainer: ASDisplayNode {
    
    var isTopicHidden: Bool = false
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    lazy var collectionNode = ASCollectionNode(collectionViewLayout: flowLayout).then {
        $0.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        $0.style.preferredSize = CGSize(width: width, height: 50)
        $0.alwaysBounceHorizontal = true
        $0.backgroundColor = .lightGray()
    }
    
    lazy var tableNode = ASTableNode().then {
        $0.style.flexGrow = 1
        $0.allowsSelectionDuringEditing = false
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension Reactive where Base: LocalPostListViewContainer {
    
    var isTopicHidden: Binder<Bool> {
        Binder(base) { base, isHidden in
            base.isTopicHidden = isHidden
            base.setNeedsLayout()
        }
    }
}

extension LocalPostListViewContainer {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if (isTopicHidden) {
            return ASWrapperLayoutSpec(layoutElement: tableNode)
        } else {
            return ASStackLayoutSpec(
                direction: .vertical,
                spacing: 0,
                justifyContent: .start,
                alignItems: .start,
                children: [collectionNode, tableNode]
            )
        }
    }
}
