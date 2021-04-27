//
//  ASCheckBoxNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/27.
//

import AsyncDisplayKit
import BEMCheckBox

class ASCheckBoxNode: ASDisplayNode {
    
    lazy var checkBoxNode = ASDisplayNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        checkBoxNode = BEMCheckBox().then {
            $0.boxType = .circle
            $0.onCheckColor = .systemBackground
                
            $0.tintColor = .lightGray
            $0.onTintColor = .primaryColor()
            $0.onFillColor = .primaryColor()
        }.toNode()
        
        self.setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: checkBoxNode)
    }
}
