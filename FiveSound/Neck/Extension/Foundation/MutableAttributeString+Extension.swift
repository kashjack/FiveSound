//
//  MutableAttributeString.swift
//  HomePlus
//
//  Created by xp on 2018/5/7.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    /// 快速创建 NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - lineSpacing: 行距
    ///   - alignment: 对齐方式
    ///   - textColor: 文字颜色
    ///   - textFont: 文字字体
    convenience init(_ text: String, lineSpacing: CGFloat, alignment: NSTextAlignment, textColor: UIColor, textFont: UIFont) {
        self.init(string: text)
        let paragragh = NSMutableParagraphStyle()
        paragragh.alignment = alignment
        paragragh.lineSpacing = lineSpacing
        
        let dic = [NSAttributedString.Key.foregroundColor: textColor,
                   NSAttributedString.Key.font      :textFont,
                   NSAttributedString.Key.paragraphStyle :paragragh,
                   NSAttributedString.Key.underlineStyle :NSNumber.init(value: 0)]
        self.setAttributes(dic, range: NSMakeRange(0, self.length))
    }
    
    
    /// 设置文字颜色
    ///
    /// - Parameters:
    ///   - color: <#color description#>
    ///   - range: <#range description#>
    func setTextColor(_ color: UIColor, range: NSRange) {
        self.removeAttribute(NSAttributedString.Key.foregroundColor, range: range)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setTextColor(_ color: UIColor) {
        setTextColor(color, range: NSMakeRange(0, self.length))
    }
    
    
    func setTextAlignment(_ textAlignment: CTTextAlignment, lineBreakMode: CTLineBreakMode, range: NSRange) {
        
    }
    
    func setFont(_ font: UIFont, range: NSRange) {
        self.removeAttribute(NSAttributedString.Key.font, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
    func setFont(_ font: UIFont) {
        self.setFont(font, range: NSMakeRange(0, self.length))
    }
    
    
//    func setText(_ text: String, lineSpacing: CGFloat, alignment: NSTextAlignment, textColor: UIColor, textFont: UIFont) {
//        
//    }
    
//    func setTextAlignment(lineBreakMode: NSLineBreakMode,
//                          lineSpacing: CGFloat,
//                          alignment: NSTextAlignment,
//                          textColor: UIColor,
//                          textFont: UIFont) {
//
//    }
}
