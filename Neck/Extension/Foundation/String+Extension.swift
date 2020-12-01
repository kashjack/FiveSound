//
//  String+Extension.swift
//  HomePlusTS
//
//  Created by worldunionViolet on 2019/3/18.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import Foundation

/**
 NSDecimalNumber
 加: decimalNumberByAdding
 减: decimalNumberBySubtracting：
 乘: decimalNumberByMultiplyingBy：
 除: decimalNumberByDividingBy
 */
enum DecimalNumberCalType : String{
    case add = "add"
    case subtract = "subtract"
    case multiply = "multiply"
    case divide = "divide"
}

//MARK: 图片处理拼接
extension String {
    //MARK: 指定宽高缩放
    var ReSizeWith_width_640: String {
        return self + "?x-oss-process=image/resize,l_640"
    }
}

//扩展String
extension String {
    //字符串的url地址转义
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    
}

extension String {
    //Base64编码
    func encodBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //Base64解码
    func decodeBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

extension String{
    
    func containsString(s:String) -> Bool
    {
        if(range(of: s) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func containsString(s:String, compareOption: NSString.CompareOptions) -> Bool
    {
        if((range(of: s, options: compareOption)) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}

// MARK: - String 扩展
extension String {
    
    /// 字符串长度
    var length: Int {
        return self.count
    }
    
    //MARK: --url编码
    public func urlStringEncoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    //MARK: --url解码
    public func urlStringDeEncoding()-> String? {
        return self.removingPercentEncoding
    }
    
    //MARK: --获取项目文件路径
    public static func documentPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        return path!
    }
    
    
    /*!
     @brief 修正浮点型精度丢失
     @param str 传入接口取到的数据
     @return 修正精度后的数据
     */
    func reviseString() -> String {
        let str:String = self
        let numStr = NSString.init(string: str)
        let conversionValue = numStr.doubleValue
        let doubleStr = NSString.init(format: "%lf", conversionValue)
        let decNumber = NSDecimalNumber.init(string: doubleStr as String)
        return decNumber.stringValue
    }
    
    //MARK: --字符串转float
    func stringToFloat()->CGFloat{
        let str:String = self
        let numStr = NSString.init(string: str)
        let conversionValue = numStr.doubleValue
        let doubleStr = NSString.init(format: "%f", conversionValue)
        let decNumber = NSDecimalNumber.init(string: doubleStr as String)
        return CGFloat(decNumber.floatValue)
    }
    
    /** 直接传入精度丢失有问题的Double类型*/
    func decimalNumberWithDouble() -> String{
        if self.length == 0 {
            return ""
        }
        let conversionValue = Double(self)
        let doubleString = String(format: "%lf", conversionValue!)       // = [NSString stringWithFormat:@"%lf", conversionValue];
        let decNumber    = NSDecimalNumber.init(string: doubleString)//Decimal.init(string: doubleString)//[NSDecimalNumber decimalNumberWithString:doubleString];
        return decNumber.stringValue//[decNumber stringValue];
    }
    
    /// 数值计算
    ///
    /// - Parameter rateValue:
    /// - Returns:
    func decimalNumberCalWith(_ number:String,_ calType:DecimalNumberCalType) -> String{
        if self.length == 0 {
            return "0"
        }
        /*手续费计算精度问题解决：NSDecimalNumber
         加: decimalNumberByAdding
         减: decimalNumberBySubtracting：
         乘: decimalNumberByMultiplyingBy：
         除: decimalNumberByDividingBy：
         NSRoundPlain,   // Round up on a tie //四舍五入
         
         NSRoundDown,    // Always down == truncate  //只舍不入
         
         NSRoundUp,      // Always up    // 只入不舍
         
         NSRoundBankers  // on a tie round so last digit is even
         */
        let double1Str = NSString.init(format: "%lf", self)
        let double2Str = NSString.init(format: "%lf", number)
        
        let number1: NSDecimalNumber = NSDecimalNumber.init(string: double1Str as String)
        let number2: NSDecimalNumber = NSDecimalNumber.init(string: double2Str as String)
        let roundUp: NSDecimalNumberHandler = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        var result:NSDecimalNumber?
        switch calType {
        case .add:
            result = number1.adding(number2, withBehavior: roundUp)
        case .subtract:
            result = number1.subtracting(number2, withBehavior: roundUp)
        case .multiply:
            result = number1.multiplying(by: number2, withBehavior: roundUp)
        case .divide:
            result = number1.dividing(by: number2, withBehavior: roundUp)
        }
        return result?.stringValue ?? "0"
    }
    
    //MARK: --字符串转Int
    func stringToInt()->Int{
        if self == "" {
            return 0
        }
        let string = self
        var int: Int?
        if let doubleValue = Int(string) {
            int = Int(doubleValue)
        }
        if int == nil
        {
            return 0
        }
        return int!
    }
    
    //MARK: --字符串转Double
    
    ///
    /*
     typedef NS_ENUM(NSUInteger, NSRoundingMode) {
     NSRoundPlain,   // Round up on a tie(四舍五入)
     NSRoundDown,    // Always down == truncate(只舍不入)
     NSRoundUp,      // Always up(只入不舍)
     NSRoundBankers  // on a tie round so last digit is even(也是四舍五入,这是和NSRoundPlain不一样,如果精确的哪位是5,
     它要看精确度的前一位是偶数还是奇数,如果是奇数,则入,偶数则舍,例如scale=1,表示精确到小数点后一位, NSDecimalNumber 为1.25时,
     NSRoundPlain结果为1.3,而NSRoundBankers则是1.2),下面是例子:
     };
     
     * scale表示精确到小数点后几位,并且NSRoundingMode影响的也是scale位
     * raiseOnExactness/raiseOnOverflow/raiseOnUnderflow raiseOnDivideByZero
     分别表示数据精确/上溢/下益/除以0时是否以异常处理,一般情况下都设置为NO
     */
    ///
    /// - Returns: <#return value description#>
    func stringToDouble()->Double{
        let str:String = self
        let numStr = NSString.init(string: str)
        let conversionValue = numStr.doubleValue
        let doubleStr = NSString.init(format: "%lf", conversionValue)
        let decNumber = NSDecimalNumber.init(string: doubleStr as String)
        return decNumber.doubleValue
    }
    
    //MARK: --DateString 转 Date
    func getDateByFormatString(_ str: String) -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = str
        dateFormat.locale = Locale.current
        return dateFormat.date(from: self)
    }
    
    //截取字符串
    func substrfromBegin(length:Int)->String{
        //        let index = self.index(self.startIndex, offsetBy: length)
        return self.substring(to: length)
    }
    
    //MARK: 替换指定字符为空
    /// 替换指定字符为空
    ///
    /// - Parameter content: content description
    /// - Returns: return value description替换指定字符为空
    func replaceIn(_ content:String) -> String {
        return self.replacingOccurrences(of: content, with: "").replacingOccurrences(of: " ", with: "")
    }
    
    func getCommonDateByFormatString() -> Date? {
        return getDateByFormatString("yyyy-MM-dd HH:mm:ss")
    }
    
    //MARK: --计算UILabel中字符串的高度
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    //MARK: --计算UILabel中字符串的宽度
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
    
    /// 字符串编码
    var unicodeStr:String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")//self.stringByReplacingOccurrencesOfString("\\u", withString: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of:"\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")// "\"".stringByAppendingString(tempStr2).stringByAppendingString("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)//tempStr3.dataUsingEncoding(NSUTF8StringEncoding)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: .mutableContainersAndLeaves, format: nil) as! String//try NSPropertyListSerialization.propertyListWithData(tempData!, options: .Immutable, format: nil) as! String
        } catch {
            debugPrint(error)
        }
        return returnStr.replacingOccurrences(of:"\\r\\n", with: "\n")
    }
    
    
    /// 删除字符串中的空格和换行符
    func deleteWhiteSpaceAndWrap() -> String {
        let characterSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: characterSet)
    }
    
    //MARK: --控制小数最多小数点后两位
    func areaStringWithFromat() ->String{
        if self == "" || self.isEmpty{
            return "0"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let num = NSNumber(floatLiteral: Double(self)!)
        let string = formatter.string(from: num)
        return string!
    }
    
    //MARK: --格式化金额，千分位
    /*!
     *  @author liujinliang, 16-12-28 14:12:49
     *
     *  @brief 格式化金额，千分位
     *
     enum{
     
     NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,123456789
     
     NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle, 123,456,789
     
     NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle, ¥123,456,789.00
     
     NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle, -539,222,988%
     
     NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle, 1.23456789E8
     
     NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle, 一亿二千三百四十五万六千七百八十九
     
     };
     
     *
     *  @param num <#num description#>
     *
     *  @return return value description
     *
     *  @since <#1.1.0#>
     */
    func formatMoneyWithNum() -> String {
        if self == "" || self.isEmpty {
            return "0"
        }
        let roundUp:NSDecimalNumberHandler = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.bankers, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let moneyNum:NSDecimalNumber = NSDecimalNumber.init(string: self)
        let moneyStr:NSDecimalNumber = moneyNum.rounding(accordingToBehavior: roundUp)
        
        return moneyStr.stringValue
    }
    
    
    
    //    /// 格式化金额
    //    func formatMoney() -> String? {
    //        let formatter = NumberFormatter()
    //        formatter.numberStyle = .currency
    //        guard let floatValue = Float(self), var resultString = formatter.string(from: NSNumber.init(value: floatValue)) else {
    //            return nil
    //        }
    //        resultString.removeSubrange(resultString.startIndex ..< resultString.index(resultString.startIndex, offsetBy: 1))
    //        return resultString
    //    }
    
    
    /// 判断是否包含表情
    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }
    
    
    /// 计算时间
    ///
    /// - Parameter requestDate: requestDate description
    /// - Returns: return value description
    func getShowFormat(requestDate:Date) -> String {
        
        //获取当前时间
        let calendar = Calendar.current
        //判断是否是今天
        if calendar.isDateInToday(requestDate as Date) {
            //获取当前时间和系统时间的差距(单位是秒)
            //强制转换为Int
            let since = Int(Date().timeIntervalSince(requestDate as Date))
            //  是否是刚刚
            if since < 60 {
                return "刚刚"
            }
            //  是否是多少分钟内
            if since < 60 * 60 {
                return "\(since/60)分钟前"
            }
            //  是否是多少小时内
            return "\(since / (60 * 60))小时前"
        }
        
        //判断是否是昨天
        var formatterString = " HH:mm"
        if calendar.isDateInYesterday(requestDate as Date) {
            formatterString = "昨天" + formatterString
        } else {
            //判断是否是一年内
            formatterString = "MM-dd" + formatterString
            //判断是否是更早期
            
            let comps = calendar.dateComponents([Calendar.Component.year], from: requestDate, to: Date())
            
            if comps.year! >= 1 {
                formatterString = "yyyy-" + formatterString
            }
        }
        
        //按照指定的格式将日期转换为字符串
        //创建formatter
        let formatter = DateFormatter()
        //设置时间格式
        formatter.dateFormat = formatterString
        //设置时间区域
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        //格式化
        return formatter.string(from: requestDate as Date)
    }
}

extension String {
    //获取子字符串
    //    func substingInRange(r: Range<Int>) -> String? {
    //        if r.lowerBound < 0 || r.upperBound > self.count{
    //            return nil
    //        }
    //        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
    //        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
    //        return //self.substring(with:startIndex..<endIndex)
    //    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
    
    // MARK:  H5文本加头
    public func headHTML() -> String {
        var htmlString = self
        htmlString = htmlString.replacingOccurrences(of: "&lt;", with: "<")
        htmlString = htmlString.replacingOccurrences(of: "&quot;", with: "\"")
        htmlString = htmlString.replacingOccurrences(of: "&gt;", with: ">")
        htmlString = htmlString.replacingOccurrences(of: "&amp;", with: "&")
        htmlString = "<!DOCTYPE html> <html lang=\"cn\"> <head> <meta charset=\"utf-8\"> <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\"> </head></html><body bgcolor=\"#ffffff\"><font color=\"\(UIColor.darkGray)\"><style>img{max-width:100%;height:auto;}</style>\(htmlString)"
        return htmlString
    }
    
}

extension String {
    
    /*
     let languages = "Java,Swift,Objective-C"
     let one = "Swift"
     let range = languages.range(of: one)
     let nsRange = "".nsRange(from: range!)
     printLog(nsRange) // {5, 5}
     */
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    ///（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    
    //返回字数
    var count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    //使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
        
    }
    
    
}

extension String {
    /**获取字符串尺寸--私有方法*/
    private func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
            return strSize
        }
        
        if attriStr != nil {
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        
        return CGSize.zero
        
    }
    
    
    /**获取字符串高度H*/
    func getNormalStrH(str: String, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    
    /**获取字符串宽度W*/
    func getNormalStrW(str: String, strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
    
    
    /**获取富文本字符串高度H*/
    func getAttributedStrH(attriStr: NSMutableAttributedString, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getNormalStrSize(attriStr: attriStr, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    
    /**获取富文本字符串宽度W*/
    func getAttributedStrW(attriStr: NSMutableAttributedString, strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getNormalStrSize(attriStr: attriStr, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
}

extension Dictionary {
    func toString() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self,options: []), let str = String(data: data, encoding:String.Encoding.utf8) {
            return str
        }
        return ""
    }
}
