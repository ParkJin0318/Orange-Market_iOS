//
//  CategoryCheckBoxCell.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import AsyncDisplayKit
import BEMCheckBox

class CategoryCheckBoxCell: ASCellNode, BEMCheckBoxDelegate {
    
    var delegate: CategoryCheckBoxCellDelegate?
    var category: ProductCategory!
    
    lazy var checkBoxNode = ASCheckBoxNode().then {
        $0.style.preferredSize = CGSize(width: 20, height: 20)
    }
    
    lazy var nameNode = ASTextNode().then {
        $0.style.flexShrink = 1
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    func setupNode(category: ProductCategory) {
        self.category = category
        nameNode.attributedText = category.name.toAttributed(color: .label, ofSize: 16)
    }
    
    override func layout() {
        super.layout()
        checkBoxNode.checkBox.delegate = self
        checkBoxNode.checkBox.on = category.isSelected
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        delegate?.setCheckedCategory(idx: category.idx)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let categoryLayout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [checkBoxNode, nameNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 5, bottom: 10, right: 5),
            child: categoryLayout
        )
    }
}
