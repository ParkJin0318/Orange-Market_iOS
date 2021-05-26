//
//  LocalContentCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/24.
//

import AsyncDisplayKit
import RxSwift

class LocalContentCell: ASCellNode {
    
    lazy var topicNode = ASTextNode().then {
        $0.backgroundColor = UIColor.lightGray()
        $0.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    lazy var profileNode = ProfileNode()
    
    lazy var contentNode = ASTextNode()
    
    lazy var separatorNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension Reactive where Base: LocalContentCell {
    
    var content: Binder<LocalPost> {
        Binder(base) { base, post in
            base.profileNode.nameNode.attributedText = post.name.toAttributed(color: .label, ofSize: 14)
            base.profileNode.profileImageNode.url = post.profileImage?.toUrl()
            base.profileNode.locationNode.attributedText = "\(post.location) · \(post.createAt)".toAttributed(color: .gray, ofSize: 12)
            
            base.topicNode.attributedText = post.topic.toAttributed(color: .label, ofSize: 12)
            base.contentNode.attributedText = post.contents.toAttributed(color: .label, ofSize: 16)
        }
    }
}

extension LocalContentCell {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentLayout = self.contentLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .stretch,
            children: [contentLayout, separatorNode]
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
