//
//  LocalPostListViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit

class LocalPostListViewContainer: ASDisplayNode {
    
    lazy var tableNode = ASTableNode().then {
        $0.allowsSelectionDuringEditing = false
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: tableNode)
    }
}
