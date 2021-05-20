//
//  LocalPostCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit
import RxSwift

class LocalPostCell: ASCellNode {
    
    lazy var topicNode = ASTextNode().then {
        $0.backgroundColor = UIColor.lightGray()
        $0.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    lazy var contentNode = ASTextNode()
    
    lazy var userInfoNode = ASTextNode()
    
    lazy var dateNode = ASTextNode()
    
    lazy var separatorNode = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 10)
        $0.backgroundColor = .lightGray()
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension Reactive where Base: LocalPostCell {
    
    var post: Binder<LocalPost> {
        Binder(base) { base, post in
            base.topicNode.attributedText = post.topic.toAttributed(color: .label, ofSize: 12)
            base.contentNode.attributedText = post.contents.toAttributed(color: .label, ofSize: 16)
            base.userInfoNode.attributedText = "\(post.name) · \(post.location)".toAttributed(color: .gray, ofSize: 12)
            base.dateNode.attributedText = post.createAt.toAttributed(color: .gray, ofSize: 12)
        }
    }
}


extension LocalPostCell {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let postLayout = self.postLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .spaceAround,
            alignItems: .stretch,
            children: [postLayout, separatorNode]
        )
    }
    
    func postLayoutSpec() -> ASLayoutSpec {
        let topInfoLayout = self.topInfoLayoutSpec()
        let bottomInfoLayout = self.bottomInfoLayoutSpec()
        
        let postLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .spaceAround,
            alignItems: .stretch,
            children: [topInfoLayout, bottomInfoLayout]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: postLayout
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
