//
//  MyInfoEditViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/12.
//

import AsyncDisplayKit

class MyInfoEditViewContainer: ASDisplayNode {
    
    lazy var profileImageNode = ASNetworkImageNode().then {
        $0.style.preferredSize = CGSize(width: 80, height: 80)
        $0.cornerRadius = 80 / 2
        $0.backgroundColor = .lightGray
    }
    
    lazy var addButton = ASButtonNode().then {
        $0.setTitle("+", with: UIFont.boldSystemFont(ofSize: 15), with: .white, for: .normal)
        $0.borderWidth = 1.5
        $0.borderColor = UIColor.primaryColor().cgColor
        $0.backgroundColor = .primaryColor()
        $0.style.preferredSize = CGSize(width: 25, height: 25)
        $0.cornerRadius = 25 / 2
    }
    
    lazy var nameField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.textAlignment = .center
        $0.contentHorizontalAlignment = .center
    }
    
    private lazy var nameNode = nameField.toNode().then {
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
        let myInfoEditLayout = self.myInfoEditLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 20, left: 20, bottom: 0, right: 20),
            child: myInfoEditLayout
        )
    }
    
    func myInfoEditLayoutSpec() -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .start,
            alignItems: .center,
            children: [profileLayout, nameNode]
        )
    }
    
    func profileLayoutSpec() -> ASLayoutSpec {
        let profileLayout = ASCornerLayoutSpec(
            child: profileImageNode,
            corner: addButton,
            location: .bottomRight
        )
        profileLayout.offset = CGPoint(x: -10, y: -10)
        return profileLayout
    }
}
