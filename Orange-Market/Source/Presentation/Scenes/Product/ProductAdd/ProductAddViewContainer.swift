//
//  ProductAddViewContainer.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import AsyncDisplayKit

class ProductAddViewContainer: ASDisplayNode {
    
    lazy var imagePickerNode = ASImageNode().then {
        $0.style.preferredSize = CGSize(width: 30, height: 30)
        $0.image = UIImage(systemName: "camera.fill")
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 60, height: 60)
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
    }
    
    lazy var collectionNode = ASCollectionNode(collectionViewLayout: flowLayout).then {
        $0.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        $0.style.preferredSize = CGSize(width: width, height: 100)
        $0.alwaysBounceHorizontal = true
        $0.backgroundColor = .systemBackground
    }
    
    lazy var imageSeparator = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    lazy var titleField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
        $0.borderStyle = .none
    }
    
    private lazy var titleNode = titleField.toNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var titleSeparator = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    lazy var categorySelectNode = ArrowButtonNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var categorySeparator = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    lazy var priceField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
        $0.borderStyle = .none
    }
    
    private lazy var priceNode = priceField.toNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var priceSeparator = ASDisplayNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 1)
        $0.backgroundColor = .lightGray()
    }
    
    lazy var contentNode = ASEditableTextNode().then {
        $0.typingAttributes = [
            NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.label
        ]
        $0.textContainerInset = .init(top: 5, left: 10, bottom: 5, right: 10)
        $0.style.preferredSize = .init(width: width, height: 300)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imagePickerLayout = self.imagePickerLayoutSpec()
        
        let containerLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                imagePickerLayout,
                imageSeparator,
                titleNode,
                titleSeparator,
                categorySelectNode,
                categorySeparator,
                priceNode,
                priceSeparator,
                contentNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 10, bottom: 0, right: 10),
            child: containerLayout
        )
    }
    
    private func imagePickerLayoutSpec() -> ASLayoutSpec {
        
        let imageListLayout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .start,
            alignItems: .center,
            children: [imagePickerNode, collectionNode]
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 20, bottom: 0, right: 0),
            child: imageListLayout
        )
    }
}
