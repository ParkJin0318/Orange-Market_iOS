//
//  LocalPostDetailViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit
import RxSwift

class LocalPostDetailViewContainer: ASDisplayNode {
    
    lazy var topicNode = ASTextNode().then {
        $0.backgroundColor = UIColor.lightGray()
        $0.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    lazy var profileNode = ProfileNode()
    
    lazy var contentNode = ASTextNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [topicNode, profileNode, contentNode]
        )
    }
}

extension Reactive where Base: LocalPostDetailViewContainer {
    
    var post: Binder<LocalPost> {
        Binder(base) { base, post in
            base.topicNode.attributedText = post.topic.toAttributed(color: .label, ofSize: 12)
            base.profileNode.nameNode.attributedText = post.name.toAttributed(color: .label, ofSize: 14)
            base.profileNode.profileImageNode.url = post.profileImage?.toUrl()
            base.profileNode.locationNode.attributedText = post.location.toAttributed(color: .gray, ofSize: 12)
            base.contentNode.attributedText = post.contents.toAttributed(color: .label, ofSize: 16)
        }
    }
}
