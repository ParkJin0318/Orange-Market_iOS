//
//  ASCheckBoxNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/27.
//

import AsyncDisplayKit
import BEMCheckBox

class ASCheckBoxNode: ASDisplayNode {
    
    var checkBox: BEMCheckBox!
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        checkBox = BEMCheckBox().then {
            $0.boxType = .circle
            $0.onCheckColor = .systemBackground
                
            $0.tintColor = .lightGray
            $0.onTintColor = .primaryColor()
            $0.onFillColor = .primaryColor()
        }
        
        self.setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if (checkBox != nil) {
            return ASWrapperLayoutSpec(layoutElement: checkBox.toNode())
        }
        return ASWrapperLayoutSpec(layoutElement: ASDisplayNode())
    }
}
