//
//  TopicCheckBoxCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit
import BEMCheckBox

class LocalTopicCheckBoxCell: ASCellNode, BEMCheckBoxDelegate {
    
    var delegate: CheckBoxCellDelegate?
    var topic: LocalTopic!
    
    lazy var checkBoxNode = ASCheckBoxNode().then {
        $0.style.preferredSize = CGSize(width: 15, height: 15)
    }
    
    lazy var nameNode = ASTextNode().then {
        $0.style.preferredSize = CGSize(width: 60, height: 20)
    }
    
    lazy var imageNode = ASImageNode().then {
        $0.style.preferredSize = CGSize(width: 40, height: 40)
        $0.cornerRadius = 40 / 2
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}

extension LocalTopicCheckBoxCell {
    
    override func layout() {
        super.layout()
        checkBoxNode.checkBox.delegate = self
        checkBoxNode.checkBox.on = topic.isSelected
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        delegate?.setCheckedItem(idx: topic.idx)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let containerLayout = self.containerLayoutSpec()
        
        let layout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .center,
            alignItems: .center,
            children: [containerLayout, nameNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 20, bottom: 20, right: 20),
            child: layout
        )
    }
    
    func containerLayoutSpec() -> ASLayoutSpec {
        let layout = ASCornerLayoutSpec(
            child: imageNode,
            corner: checkBoxNode,
            location: .topRight
        )
        layout.offset = CGPoint(x: -5, y: 10)
        
        return layout
    }
}
