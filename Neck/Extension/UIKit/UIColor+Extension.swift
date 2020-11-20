//
//  UIColor+Extension.swift
//  HomePlus
//
//  Created by xp on 2018/4/25.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import Foundation
import UIKit


public extension UIColor {
    
    //16进制颜色值转UIColor
    static func hexStringToColor(_ hexString: String, _ alpha: CGFloat = 1) -> UIColor{
        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: 2)}//(from: cString.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#") {cString = cString.substring(from: 1)}//(from: cString.index(cString.startIndex, offsetBy: 1))}
        if cString.count != 6 {return UIColor.black}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    // 主颜色
    static var mainColor: UIColor {
        get {
            return hexStringToColor("#1FD18F")
        }
    }

    static var disableColor: UIColor {
        get {
            return hexStringToColor("#1FD18F", 0.5)
        }
    }

    // 背景颜色
    static var backgroundColor: UIColor {
        get {
            return hexStringToColor("f3f4f8")
        }
    }

    
    //MARK: -文字颜色，次级灰色
    /*!
     文字颜色，次级灰色
     
     - returns: return value description
     */
    static var fontLightGray:UIColor {
        get {
            return hexStringToColor("dce2e6")
        }
    }
    
    //MARK: -积分，黄色
    /*!
     积分，黄色
     
     - returns: return value description
     */
    static var integralColor:UIColor {
        get {
            return hexStringToColor("fac000")
        }
    }
    
    //MARK: -tabbar线条颜色
    /*!
     积分，黄色
     
     - returns: return value description
     */
    static var tabBarLineColor:UIColor {
        get {
            return hexStringToColor("ebedf2")
        }
    }
    
    //MARK: --积分模块：已完成的颜色
    /// --
    ///
    /// - Returns: color
    static var integralProgressFullColor:UIColor {
        get {
            return hexStringToColor("7aaeff")
        }
    }
    
    //MARK: --积分模块：进行中的颜色
    /// --
    ///
    /// - Returns: color
    static var integralProgressDoingColor:UIColor {
        get {
            return hexStringToColor("ff919c")
        }
    }
    
    //MARK: --TextFieldColor
    //MARK: -- 提示
    static var textPlaceholderColor:UIColor {
        get {
            return hexStringToColor("cfd6db")
        }
    }
    
    //MARK: -- 输入后
    static var textInputEndColor:UIColor {
        get {
            return hexStringToColor("141414")
        }
    }
    
    //MARK: --不可修改
    static var textNoEditColor:UIColor {
        get {
            return hexStringToColor("9ea3a6")
        }
    }
    
    //MARK: --按钮Normal颜色
    /// --按钮Normal颜色
    ///
    /// - Returns: UIColor
    static var buttonNormalColor:UIColor {
        get {
            return hexStringToColor("ee1a1a")
        }
    }
    
    //MARK: --按钮Highlighted颜色
    /// --按钮Highlighted颜色
    ///
    /// - Returns: UIColor
    static var buttonHighlightedColor:UIColor {
        get {
            return hexStringToColor("ef8787")
        }
    }
    
    //MARK: --按钮Disabled颜色
    /// --按钮Disabled颜色
    ///
    /// - Returns: UIColor
    static var buttonDisabledColor:UIColor {
        get {
            return hexStringToColor("ef8787")//backgroundColor
        }
    }
    
    //MARK: --按钮Selected颜色
    /// --按钮Selected颜色
    ///
    /// - Returns: UIColor
    static var buttonSelectedColor:UIColor {
        get {
            return hexStringToColor("ee1a1a")
        }
    }
    
    //MARK: --按钮Focused颜色
    /// --按钮Focused颜色
    ///
    /// - Returns: UIColor
    static var buttonFocusedColor:UIColor {
        get {
            return fontLightGray
        }
    }
    
    //MARK: --按钮点击颜色
    
    
    //主题色
    static var applicationMainColor:UIColor {
        get {
            return UIColor(red: 238/255, green: 64/255, blue: 86/255, alpha:1)
        }
    }
    
    //第二主题色
    static var applicationSecondColor:UIColor {
        get {
            return UIColor.lightGray
        }
    }
    
    //警告颜色
    static var applicationWarningColor:UIColor {
        get {
            return UIColor(red: 0.1, green: 1, blue: 0, alpha: 1)
        }
    }
    
    //链接颜色
    static var applicationLinkColor:UIColor {
        get {
            return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha:1)
        }
    }
    
    ///回复蓝色
    static var replyColor:UIColor {
        get {
            return hexStringToColor("4786cd")
        }
    }
    
    //MARK: --颜色转图片
    func kCreateImageWithColor() -> UIImage {
        let rect = CGRect(x:0.0, y:0.0,width:1.0,height:1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
    
    /**
     Create non-autoreleased color with in the given hex string
     Alpha will be set as 1 by default
     
     - parameter   hexString:
     - returns: color with the given hex string
     */
    
    /**
     Create non-autoreleased color with in the given hex value and alpha
     
     - parameter   hex:
     - parameter   alpha:
     - returns: color with the given hex value and alpha
     */

    
    //MARK: --获取随机颜色
    class func randomColor() -> UIColor {
        printLog(CGFloat(arc4random_uniform(256)))
        return UIColor(red: CGFloat(arc4random_uniform(256)), green: CGFloat(arc4random_uniform(256)), blue: CGFloat(arc4random_uniform(256)), alpha: 1.0)
        //        return UIColor(red: CGFloat(arc4random_uniform(256)), greed: CGFloat(arc4random_uniform(256)), blue: CGFloat(arc4random_uniform(256)),alpha:1.0)
    }
}
//
//
//public extension UIColor {
//    // user:UIColor.init(hexString: "#ff5a10") ||UIColor.init(hexString: "ff5a10")
//    convenience init(hexString: String, alpha: CGFloat = 1) {
//        var r, g, b, a: CGFloat
//        a = alpha
//        var hexColor: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//        // 存在#，则将#去掉
//        if (hexColor.hasPrefix("#")) {
//            let splitIndex = hexColor.index(after: hexColor.startIndex)
//            hexColor = String(hexColor[splitIndex...])
//        }
//        if hexColor.count == 8 {
//            let scanner = Scanner(string: hexColor)
//
//            var hexNumber: UInt64 = 0
//
//            if scanner.scanHexInt64(&hexNumber) {
//                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                self.init(red: r, green: g, blue: b, alpha: a)
//                return
//            }
//        } else if hexColor.count == 6 {
//            let scanner = Scanner(string: hexColor)
//            var hexNumber: UInt64 = 0
//
//            if scanner.scanHexInt64(&hexNumber) {
//                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
//                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
//                b = CGFloat(hexNumber & 0x0000ff) / 255
//                self.init(red: r, green: g, blue: b, alpha: a)
//                return
//            }
//        }
//        // 设置默认值
//        self.init(white: 0.0, alpha: 1)
//    }
//
//    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
//    //user: UIColor.init(valueHex: 0xff5a10)
//    convenience init(valueHex: UInt, alpha: CGFloat = 1.0) {
//
//        self.init(
//            red: CGFloat((valueHex & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((valueHex & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(valueHex & 0x0000FF) / 255.0,
//            alpha: alpha
//        )
//    }
//
//    /// 获取随机颜色
//    /// - Returns: 随机颜色
//    class func randamColor() -> UIColor{
//        let R = CGFloat(arc4random_uniform(255))/255.0
//        let G = CGFloat(arc4random_uniform(255))/255.0
//        let B = CGFloat(arc4random_uniform(255))/255.0
//        return UIColor.init(red: R, green: G, blue: B, alpha: 1)
//    }
//
//    /// 生产渐变颜色
//    ///
//    /// - Parameters:
//    ///   - from: 开始的颜色
//    ///   - toColor: 结束的颜色
//    /// - Returns: 渐变颜色
//    class func gradientColor(_ fromColor: UIColor, toColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
//        let size = CGSize.init(width: endPoint.x - startPoint.x, height: endPoint.y - startPoint.y)
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        let context = UIGraphicsGetCurrentContext()
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let colors = [fromColor.cgColor, toColor.cgColor]
//
//        guard let gradient: CGGradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil) else { return nil }
//
//        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
//
//        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//
//        UIGraphicsEndImageContext()
//
//        return UIColor.init(patternImage: image)
//    }
//
//    /// 获取对应的rgba值
//    var component: (CGFloat,CGFloat,CGFloat,CGFloat) {
//        get {
//            var r: CGFloat = 0
//            var g: CGFloat = 0
//            var b: CGFloat = 0
//            var a: CGFloat = 0
//            getRed(&r, green: &g, blue: &b, alpha: &a)
//            return (r * 255,g * 255,b * 255,a)
//        }
//    }
//}
//
