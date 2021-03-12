//
//  UIView+Ex.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import AsyncDisplayKit

extension UIView {
    
    func toNode() -> ASDisplayNode {
        return ASDisplayNode(viewBlock: { self })
    }
}
