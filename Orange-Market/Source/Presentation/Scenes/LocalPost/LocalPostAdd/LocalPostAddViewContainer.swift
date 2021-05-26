//
//  LocalPostAddViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit

class LocalPostAddViewContainer: ASDisplayNode {
    
    lazy var topicSelectNode = ArrowButtonNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var contentField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
        $0.borderStyle = .none
    }
    
    private lazy var contentNode = contentField.toNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var viewNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let topicSelectLayout = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 0, bottom: 10, right: 0),
            child: topicSelectNode
        )
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 3,
            justifyContent: .start,
            alignItems: .start,
            children: [
                topicSelectLayout,
                viewNode,
                contentNode
            ]
        )
    }
}
