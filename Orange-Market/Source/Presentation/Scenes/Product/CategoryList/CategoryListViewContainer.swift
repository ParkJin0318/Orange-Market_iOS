//
//  CategoryListViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/28.
//

import AsyncDisplayKit

class CategoryListViewContainer: ASDisplayNode {
    
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
