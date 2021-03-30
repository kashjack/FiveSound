//
//  Double+Extension.swift
//  HomePlus
//
//  Created by worldunionViolet on 2018/2/27.
//  Copyright © 2018年 worldunion. All rights reserved.

extension Double {

    /// 转化为百分比
    /// - Parameter decimalCount: 保留小数位
    func kPercent(_ minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = maximumFractionDigits //设置小数点后最多3位
        formatter.minimumFractionDigits = minimumFractionDigits //设置小数点后最少2位（不足补0）
        return formatter.string(from: NSNumber.init(value: self / 100)) ?? ""
    }

    /// 转化为百分比
    /// - Parameter decimalCount: 保留小数位
    func kFormatPercent(_ decimalCount: Int = 0) -> String {
        if self > 1 { return "100%"}
        let percent = String(format: "%.\(decimalCount)f", self / 100)
        return "\(percent)%"
    }

    func kFormatMoney(_ roundingModel: NSDecimalNumber.RoundingMode = .plain) -> String {
        if self == 0 { return "0" }
        let roundUp: NSDecimalNumberHandler = NSDecimalNumberHandler.init(roundingMode: roundingModel, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let doubleStr = NSString.init(format: "%lf", self)
        let moneyNum:NSDecimalNumber = NSDecimalNumber.init(string: doubleStr as String)
        let moneyStr:NSDecimalNumber = moneyNum.rounding(accordingToBehavior: roundUp)
        let format = NumberFormatter()
        format.positiveFormat = ",###.00;"
        format.numberStyle = .decimal
        debugPrint(moneyStr.stringValue)
        let num = NSNumber.init(value: moneyStr.doubleValue)
        let string = format.string(from: num)
        return string!
    }
    
    public enum RoundingMode : UInt {
        case plain//四舍五入
        
        case down//舍
        
        case up//入
        
        case bankers//貌似四舍五入
    }
    
    func formatWithDouble(_ raise:RoundingMode = RoundingMode.plain) -> String {
        
        var roundUp:NSDecimalNumberHandler?
        switch raise {
        case .plain:
            roundUp = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
            break
        case .down:
            roundUp = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
            break
        case .up:
            roundUp = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.up, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
            break
        case .bankers:
            roundUp = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.bankers, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
            break
        }
        let doubleStr = NSString.init(format: "%lf", self)
        let moneyNum:NSDecimalNumber = NSDecimalNumber.init(string: doubleStr as String)
        let moneyStr:NSDecimalNumber = moneyNum.rounding(accordingToBehavior: roundUp)
        var string = moneyStr.stringValue//format.string(from: num)
        if string.containsString(s: "Na") {
            string = "0"
        }
        return string
    }
    
    func formatWithDoubleUp() -> String {
        
        let roundUp:NSDecimalNumberHandler = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let doubleStr = NSString.init(format: "%lf", self)
        let moneyNum:NSDecimalNumber = NSDecimalNumber.init(string: doubleStr as String)
        let moneyStr:NSDecimalNumber = moneyNum.rounding(accordingToBehavior: roundUp)
        //        let format = NumberFormatter()
        ////        format.positiveFormat = ".00;"
        //        format.positiveFormat = "###.00;"
        //        format.numberStyle = .decimal
        //        debugPrint(moneyStr.stringValue)
        //        let num = NSNumber.init(value: moneyStr.doubleValue)
        var string = moneyStr.stringValue//format.string(from: num)
        if string.containsString(s: "Na") {
            string = "0"
        }
        return string
    }
    
    //MARK: 金额除以100
    func percentPriceAmount() -> String {
        let amount = self / 100
        let doubleStr = NSString.init(format: "%lf", amount)
        let moneyNum:NSDecimalNumber = NSDecimalNumber.init(string: doubleStr as String)
        
        let roundUp = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        
        let moneyStr:NSDecimalNumber = moneyNum.rounding(accordingToBehavior: roundUp)
        let format = NumberFormatter()
        format.positiveFormat = ",###0.00;"
        format.numberStyle = .decimal
        let num = NSNumber.init(value: moneyStr.doubleValue)
        if let string = format.string(from: num) {
            let strs = string.components(separatedBy: ".")
            let last = strs.last!
            if strs.count == 2 && last == "00"{
                let indexEndOfText = string.index(string.endIndex, offsetBy:-3)
                return String(string[..<indexEndOfText])
            }else{
                return string
            }
        }else{
            return "0"
        }
    }
    
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    /// 数值计算
    ///
    /// - Parameter rateValue:
    /// - Returns:
    func decimalNumberCalWith(_ number:Double,_ calType:DecimalNumberCalType) -> Double{
        
        /*手续费计算精度问题解决：NSDecimalNumber
         加: decimalNumberByAdding
         减: decimalNumberBySubtracting：
         乘: decimalNumberByMultiplyingBy：
         除: decimalNumberByDividingBy：
         */
        let double1Str = NSString.init(format: "%lf", self)
        let double2Str = NSString.init(format: "%lf", number)
        
        let number1: NSDecimalNumber = NSDecimalNumber.init(string: double1Str as String)
        let number2: NSDecimalNumber = NSDecimalNumber.init(string: double2Str as String)
        
        let roundUp = NSDecimalNumberHandler.init(roundingMode: NSDecimalNumber.RoundingMode.bankers, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        switch calType {
        case .add:
            return number1.adding(number2, withBehavior: roundUp).doubleValue
        case .subtract:
            return number1.subtracting(number2, withBehavior: roundUp).doubleValue
        case .multiply:
            return number1.multiplying(by: number2, withBehavior: roundUp).doubleValue
        case .divide:
            return number1.dividing(by: number2, withBehavior: roundUp).doubleValue
        }
    }

// MARK:  区间数
    func roundToDecimalDigits(decimals:Int) -> Double
    {
        let a : Double = self
        let format : NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.roundingMode = NumberFormatter.RoundingMode.halfUp
        format.maximumFractionDigits = 2
        let string: NSString = format.string(from: NSNumber(value: a as Double))! as NSString
       debugPrint(string.doubleValue)
        return string.doubleValue
    }
}


extension CGFloat {
    // MARK: 取区间数
    func getRangeValue(from: CGFloat, to: CGFloat) -> CGFloat {
        if self < from {
            return from
        } else if self > to {
            return to
        } else{
            return self
        }
    }

}

extension Double{

}
