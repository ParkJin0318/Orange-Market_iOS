//
//  LocalCommentCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/21.
//

import AsyncDisplayKit
import RxSwift

class LocalCommentCell: ASCellNode {
    
    lazy var profileNode = ProfileNode()
    
    lazy var commentNode = ASTextNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        profileNode.viewNode.isHidden = true
    }
}

extension Reactive where Base: LocalCommentCell {
    
    var comment: Binder<LocalComment> {
        Binder(base) { base, post in
            base.profileNode.nameNode.attributedText = post.name.toAttributed(color: .label, ofSize: 14)
            base.profileNode.profileImageNode.url = post.profileImage?.toUrl()
            base.profileNode.locationNode.attributedText = "\(post.location) · \(post.createAt)".toAttributed(color: .gray, ofSize: 12)
            
            base.commentNode.attributedText = post.comment.toAttributed(color: .label, ofSize: 14)
        }
    }
}

extension LocalCommentCell {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let commentLayout = ASInsetLayoutSpec(
            insets: .init(top: -10, left: 40, bottom: 0, right: 0),
            child: commentNode
        )
        
        let layout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: [profileNode, commentLayout]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: layout
        )
    }
}
