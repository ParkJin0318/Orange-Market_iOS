//
//  ProfileNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/22.
//

import AsyncDisplayKit

class ProfileNode: ASDisplayNode {
    
    lazy var profileImageNode = ASNetworkImageNode().then {
        $0.style.preferredSize = CGSize(width: 30, height: 30)
        $0.cornerRadius = 30 / 2
    }
    
    lazy var nameNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var locationNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var viewNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        
        let viewLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .start,
            alignItems: .start,
            children: [profileLayout, viewNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 5, left: 20, bottom: 5, right: 20),
            child: viewLayout
        )
    }
    
    private func profileLayoutSpec() -> ASLayoutSpec {
        let userInfoLayout = self.userInfoLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .start,
            alignItems: .center,
            children: [profileImageNode, userInfoLayout]
        )
    }
    
    private func userInfoLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 3,
            justifyContent: .start,
            alignItems: .start,
            children: [nameNode, locationNode]
        )
    }
}
