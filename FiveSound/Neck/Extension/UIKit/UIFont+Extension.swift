//
//  UIFont+Extension.swift
//  JiKePlus
//
//  Created by liujinliang on 16/6/12.
//  Copyright © 2016年 liujinliang. All rights reserved.
//
import Foundation
import UIKit
#if os(iOS)
import UIKit
typealias SWFont = UIFont
#else
import Cocoa
typealias SWFont = NSFont
#endif
public extension SWFont {
  
    static func kFontWithSize(_ size: CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: size/2)
    }
    
    class var fontBigContent:UIFont {
        get {
            return kFontWithSize(32)
        }
    }
    
    //MARK: --正文内容字体
    /*!
     正文内容字体--
     
     - returns: return value description
     */
    class var fontContent:UIFont {
        get {
            return kFontWithSize(28)
        }
    }
    
    //MARK: --标题字体
    /*!
     标题字体
     
     - returns: return value description
     */
    class var fontTitle:UIFont {
        get {
            return kFontWithSize(34)
        }
    }
    
    //MARK: --提示信息、三级按钮
    /*!
     提示信息、三级按钮
     
     - returns: return value description
     */
    class var fontPrompt:UIFont {
        get {
            return kFontWithSize(24)
        }
    }
    
    //MARK: 字体 10
    /*!
     次要内容(时间、标签) 24px
     
     - returns: return value description
     */
    class var fontAssistant:UIFont {
        get {
            return kFontWithSize(20)
        }
    }
    /// 大字体 60
    ///
    /// - Returns: return value description
    class var fontSixty:UIFont {
        get {
            return kFontWithSize(60)
        }
    }
    //MARK: --大字体 72
    
    
    /// 大字体 72
    ///
    /// - Returns: return value description
    class var fontBig: UIFont {
        get {
            return kFontWithSize(72)
        }
    }
}

