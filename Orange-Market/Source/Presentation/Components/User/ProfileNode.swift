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
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        
        return profileLayout
    }
    
    private func profileLayoutSpec() -> ASLayoutSpec {
        let userInfoLayout = self.userInfoLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
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
