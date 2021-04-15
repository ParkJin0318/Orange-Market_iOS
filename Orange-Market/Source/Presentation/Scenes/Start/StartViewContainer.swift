//
//  StartContainerNode.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import AsyncDisplayKit

class StartViewContainer: ASDisplayNode {
    
    lazy var titleNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var imageNode = ASImageNode()
    
    lazy var subheadNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var descriptionNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    lazy var startNode = ASButtonNode().then {
        $0.cornerRadius = 5
        $0.style.preferredSize = CGSize(width: width - 20, height: 50)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension StartViewContainer {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let startLayout = self.startLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 50, left: 20, bottom: 50, right: 20),
            child: startLayout
        )
    }
    
    func startLayoutSpec() -> ASLayoutSpec {
        let descriptionLayout = self.descriptionLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .spaceAround,
            alignItems: .center,
            children: [titleNode, imageNode, descriptionLayout, startNode]
        )
    }
    
    func descriptionLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            children: [subheadNode, descriptionNode]
        )
    }
}
