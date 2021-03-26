//
//  RegisterContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/26.
//

import AsyncDisplayKit

class RegisterContainerNode: ASDisplayNode {
    
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
    
    lazy var idTitleNode = ASTextNode()
    lazy var idNode = ASTextNode()
    
    lazy var nameTitleNode = ASTextNode()
    lazy var nameNode = ASTextNode()
    
    lazy var locationTitleNode = ASTextNode()
    lazy var locationNode = ASTextNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let registerLayout = self.registerLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 20, left: 20, bottom: 20, right: 20),
            child: registerLayout
        )
    }
    
    func registerLayoutSpec() -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        let userIdLayout = self.userIdLayoutSpec()
        let userNameLayout = self.userNameLayoutSpec()
        let locationLayout = self.locationLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 30,
            justifyContent: .center,
            alignItems: .start,
            children: [profileLayout, userIdLayout, userNameLayout, locationLayout]
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
    
    func userIdLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .start,
            children: [idTitleNode, idNode]
        )
    }
    
    func userNameLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .start,
            children: [nameTitleNode, nameNode]
        )
    }
    
    func locationLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .start,
            children: [locationTitleNode, locationNode]
        )
    }
}
