//
//  ProductAddContainer.swift
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
    
    lazy var titleField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
        $0.borderStyle = .none
    }
    
    private lazy var titleNode = titleField.toNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    lazy var categorySelectNode = ArrowButtonNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
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
    
    lazy var contentField = UITextField().then {
        $0.keyboardType = .namePhonePad
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
        $0.borderStyle = .none
    }
    
    private lazy var contentNode = contentField.toNode().then {
        $0.style.preferredSize = CGSize(width: width, height: 40)
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imagePickerLayout = self.imagePickerLayoutSpec()
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 3,
            justifyContent: .start,
            alignItems: .start,
            children: [
                imagePickerLayout,
                titleNode,
                categorySelectNode,
                priceNode,
                contentNode]
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
