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
    
    func toDate() -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format.date(from: self)!
    }
    
    func distanceDate() -> String {
        let MIN = 60
        let HOUR = MIN * MIN
        let DAY = HOUR * 24
        
        let now = Date()
        let createAt = self.toDate()
        
        let result = Int(now.timeIntervalSince1970 - createAt.timeIntervalSince1970)
        
        var temp = result
        
        var day = 0
        var hour = 0
        var min = 0
        
        while temp > 60 {
            if (temp > DAY) {
                day += 1
                temp -= DAY
            } else if (temp > HOUR) {
                hour += 1
                temp -= HOUR
            } else if (temp > MIN) {
                min += 1
                temp -= MIN
            }
        }
        
        if (day > 0) {
            return "\(day)일 전"
        } else if (hour > 0) {
            return "\(hour)시간 전"
        } else {
            return "\(min)분 전"
        }
    }
}
