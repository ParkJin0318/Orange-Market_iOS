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
    
    lazy var moreNode = ASImageNode().then {
        $0.image = UIImage(systemName: "ellipsis")
        $0.tintColor = .label
        $0.isHidden = true
    }
    
    lazy var commentNode = ASTextNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension Reactive where Base: LocalCommentCell {
    
    var comment: Binder<LocalComment> {
        Binder(base) { base, comment in
            base.profileNode.nameNode.attributedText = comment.name.toAttributed(color: .label, ofSize: 14)
            base.profileNode.profileImageNode.url = comment.profileImage?.toUrl()
            base.profileNode.locationNode.attributedText = "\(comment.location) · \(comment.createAt)".toAttributed(color: .gray, ofSize: 12)
            
            base.commentNode.attributedText = comment.comment.toAttributed(color: .label, ofSize: 14)
        }
    }
}

extension LocalCommentCell {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let containerLayout = self.containerLayoutSpec()
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: containerLayout
        )
    }
    
    func containerLayoutSpec() -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        
        let commentLayout = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 40, bottom: 0, right: 0),
            child: commentNode
        )
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .stretch,
            children: [profileLayout, commentLayout]
        )
    }
    
    func profileLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [profileNode, moreNode])
    }
}
