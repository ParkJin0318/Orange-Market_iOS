//
//  String+Ex.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import AsyncDisplayKit

extension String {
    
    func toAttributed(color: UIColor, ofSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize),
                NSAttributedString.Key.foregroundColor: color
            ]
        )
    }
    
    func toCenterAttributed(color: UIColor, ofSize: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        return NSAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize),
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.paragraphStyle: paragraph
            ]
        )
    }
    
    func toBoldAttributed(color: UIColor, ofSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: ofSize),
                NSAttributedString.Key.foregroundColor: color
            ]
        )
    }
    
    func toFontAttributed(color: UIColor, fontName: String, ofSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.font: UIFont(name: fontName, size: ofSize)!,
                NSAttributedString.Key.foregroundColor: color
            ]
        )
    }
    
    func toUrl() -> URL? {
        return URL(string: HOST + "images/" + self)
    }
}

