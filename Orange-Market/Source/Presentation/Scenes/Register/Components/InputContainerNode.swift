//
//  RegisterContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/24.
//

import AsyncDisplayKit

class InputContainerNode: ASDisplayNode {
    
    lazy var stepNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var titleNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var inputField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
    }
    
    private lazy var inputNode = inputField.toNode().then {
        $0.borderColor = UIColor.lightGray.cgColor
        $0.borderWidth = 1
        $0.cornerRadius = 5
        $0.style.preferredSize = CGSize(width: width - 40, height: 40)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let registerLayout = self.registerLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 200, left: 20, bottom: 0, right: 0),
            child: registerLayout
        )
    }
    
    private func registerLayoutSpec() -> ASLayoutSpec {
        let titleLayout = self.titleLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 40,
            justifyContent: .start,
            alignItems: .start,
            children: [titleLayout, inputNode]
        )
    }
    
    private func titleLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .start,
            children: [stepNode, titleNode]
        )
    }
}
