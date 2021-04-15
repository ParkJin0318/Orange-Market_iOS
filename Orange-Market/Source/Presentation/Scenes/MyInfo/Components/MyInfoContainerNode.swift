//
//  MyInfoContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import AsyncDisplayKit

class MyInfoContainerNode: ASScrollNode {
    
    lazy var profileNode = ProfileNode()
    
    lazy var profileOpenNode = ASButtonNode().then {
        $0.borderWidth = 1
        $0.borderColor = UIColor.lightGray.cgColor
        $0.cornerRadius = 5
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var salesNode = OrangeButtonNode()
    lazy var buyNode = OrangeButtonNode()
    lazy var attentionNode = OrangeButtonNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.automaticallyManagesContentSize = true
        
        self.scrollableDirections = [.up, .down]
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let myInfoLayout = self.myInfoLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 20, left: 10, bottom: 10, right: 10),
            child: myInfoLayout
        )
    }
    
    private func myInfoLayoutSpec() -> ASLayoutSpec {
        let salesLayout = self.salesLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [profileNode, profileOpenNode, salesLayout]
        )
    }
    
    private func salesLayoutSpec() -> ASLayoutSpec {
        
        let salesLayout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [salesNode, buyNode, attentionNode]
        ).then {
            $0.style.preferredSize = CGSize(width: width, height: 100)
        }
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 40, bottom: 10, right: 40),
            child: salesLayout
        )
    }
}
