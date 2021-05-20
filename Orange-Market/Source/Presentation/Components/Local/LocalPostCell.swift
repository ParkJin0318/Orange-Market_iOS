//
//  LocalPostCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit

class LocalPostCell: ASCellNode {
    
    lazy var topicNode = ASTextNode()
    
    lazy var contentNode = ASTextNode()
    
    lazy var userInfoNode = ASTextNode()
    
    lazy var dateNode = ASTextNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    func setupNode(post: LocalPost) {
        topicNode.attributedText = post.topic.toAttributed(color: .label, ofSize: 14)
        contentNode.attributedText = post.contents.toAttributed(color: .label, ofSize: 16)
        userInfoNode.attributedText = "\(post.name) * \(post.location)".toAttributed(color: .gray, ofSize: 14)
        dateNode.attributedText = post.createAt.toAttributed(color: .gray, ofSize: 14)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let postLayout = self.postLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: postLayout
        )
    }
    
    func postLayoutSpec() -> ASLayoutSpec {
        let topInfoLayout = self.topInfoLayoutSpec()
        let bottomInfoLayout = self.bottomInfoLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .spaceAround,
            alignItems: .stretch,
            children: [topInfoLayout, bottomInfoLayout]
        )
    }
    
    func topInfoLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [topicNode, contentNode]
        )
    }
    
    func bottomInfoLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [userInfoNode, dateNode]
        )
    }
}
