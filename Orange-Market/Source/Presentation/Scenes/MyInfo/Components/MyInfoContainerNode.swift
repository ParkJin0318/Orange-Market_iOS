//
//  MyInfoContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import AsyncDisplayKit

class MyInfoContainerNode: ASDisplayNode {
    
    lazy var profileNode = ProfileNode()
    
    lazy var profileOpenNode = ASButtonNode().then {
        $0.borderWidth = 1
        $0.borderColor = UIColor.lightGray.cgColor
        $0.cornerRadius = 5
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let myInfoLayout = self.myInfoLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 20, left: 10, bottom: 10, right: 10),
            child: myInfoLayout
        )
    }
    
    private func myInfoLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [profileNode, profileOpenNode]
        )
    }
}
