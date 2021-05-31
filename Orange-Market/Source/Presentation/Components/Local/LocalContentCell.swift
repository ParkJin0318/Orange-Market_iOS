//
//  LocalContentCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/24.
//

import AsyncDisplayKit

class LocalContentCell: ASCellNode {
    
    lazy var topicNode = ASTextNode().then {
        $0.backgroundColor = UIColor.lightGray()
        $0.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    lazy var profileNode = ProfileNode()
    
    lazy var contentNode = ASTextNode()
    
    lazy var contentSeparatorNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    lazy var commentNode = ASButtonNode().then {
        $0.imageNode.image = UIImage(systemName: "message")
        $0.imageNode.style.preferredSize = .init(width: 15, height: 15)
        $0.alpha = 0.7
    }
    
    lazy var commentSeparatorNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    init(post: LocalPost) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        
        self.profileNode.nameNode.attributedText = post.name.toAttributed(color: .label, ofSize: 14)
        self.profileNode.profileImageNode.url = post.profileImage?.toUrl()
        self.profileNode.locationNode.attributedText = "\(post.location) · \(post.createAt.distanceDate())".toAttributed(color: .gray, ofSize: 12)
        
        self.topicNode.attributedText = post.topic.toAttributed(color: .label, ofSize: 12)
        self.contentNode.attributedText = post.contents.toAttributed(color: .label, ofSize: 16)
        
        let comment = post.commentCount == 0 ? "댓글 쓰기" : "댓글 \(post.commentCount)"
        self.commentNode.titleNode.attributedText = comment.toAttributed(color: .label, ofSize: 12)
    }
}

extension LocalContentCell {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentLayout = self.contentLayoutSpec()
        let commentLayout = self.commentLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                contentLayout,
                contentSeparatorNode,
                commentLayout,
                commentSeparatorNode
            ]
        )
    }
    
    func commentLayoutSpec() -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 10, bottom: 0, right: .infinity),
            child: commentNode
        )
    }
    
    func contentLayoutSpec() -> ASLayoutSpec {
        let postLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [topicNode, profileNode, contentNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 0, right: 10),
            child: postLayout
        )
    }
}
