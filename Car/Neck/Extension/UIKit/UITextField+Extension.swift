//
//  UITextField+Extension.swift
//  HomePlus
//
//  Created by liujinliang on 2017/4/13.
//  Copyright © 2017年 worldunion. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    //MARK: --设置文本框右间距
    /// 设置文本框右间距
    ///
    /// - Parameter leftWidth: 间距大小
    public func setTextFieldLeftPaddingWidth(leftWidth: CGFloat) {
        var frame: CGRect = self.frame
        frame.size.width = leftWidth
        let leftView = UIView.init(frame: frame)
        leftViewMode = .always
        self.leftView = leftView
    }
    
    //MARK: --配置Placeholder的颜色
    func setTextColor() {
        if (placeholder?.isEmpty)! {
            placeholder = "请输入"
        }
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.textPlaceholderColor])
        textColor = UIColor.textInputEndColor
    }
    
    //MARK: --限制输入框只能输入带两位小数的数字--一般用于输入金额
    func numberOfMatchPointOne(_ range:NSRange,_ string:String) -> Bool{
        let content:NSString = (self.text ?? "") as NSString
        if content.length == 0  {
            return true
        }
        let newString = content.replacingCharacters(in: range, with: string)//.stringByReplacingCharactersInRange(range, withString: string)
        let expression = "^(0?|[1-9][0-9]*)(\\.[0-9]{0,2})?$"//"^[0-9]*(?:\\.[0-9]{0,2})?$"//"^[0-9]*((\\\\.|,)[0-9]{0,2})?$"
        let regex = try! NSRegularExpression.init(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)//NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: (newString as NSString).length))//.numberOfMatchesInString(newString, options:NSMatchingOptions.ReportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
    }
}

