//
//  LoginViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import AsyncDisplayKit

class LoginViewContainer: ASDisplayNode {
    
    lazy var imageNode = ASImageNode()
    
    lazy var descriptionNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var idField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
    }
    
    lazy var passwordField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
    }
    
    private lazy var idNode = idField.toNode().then {
        $0.borderColor = UIColor.lightGray.cgColor
        $0.borderWidth = 1
        $0.cornerRadius = 5
        $0.style.preferredSize = CGSize(width: width - 40, height: 40)
    }
    
    private lazy var passwordNode = passwordField.toNode().then {
        $0.borderColor = UIColor.lightGray.cgColor
        $0.borderWidth = 1
        $0.cornerRadius = 5
        $0.style.preferredSize = CGSize(width: width - 40, height: 40)
    }
    
    lazy var loginNode = ASButtonNode().then {
        $0.style.preferredSize = CGSize(width: width - 40, height: 50)
        $0.backgroundColor = .lightGray
        $0.cornerRadius = 5
    }
    
    lazy var guideNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var registerNode = ASButtonNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension LoginViewContainer {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let loginLayout = self.loginLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 110, left: 10, bottom: 10, right: 10),
            child: loginLayout
        )
    }
    
    private func loginLayoutSpec() -> ASLayoutSpec {
        let descriptionLayout = self.descriptionLayoutSpec()
        let guideLayout = self.guideLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 15,
            justifyContent: .start,
            alignItems: .center,
            children: [descriptionLayout, idNode, passwordNode, loginNode, guideLayout]
        )
    }
    
    private func descriptionLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .spaceAround,
            alignItems: .center,
            children: [imageNode, descriptionNode]
        )
    }
    
    private func guideLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .center,
            alignItems: .center,
            children: [guideNode, registerNode]
        )
    }
}
