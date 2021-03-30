//
//  Int64+Extension.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/11/16.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit

extension Int {



    var isEven:Bool     {return (self % 2 == 0)}
    var isOdd:Bool      {return (self % 2 != 0)}
    var isPositive:Bool {return (self >= 0)}
    var isNegative:Bool {return (self < 0)}
    var toDouble:Double {return Double(self)}
    var toFloat:Float   {return Float(self)}
    var toCGFloat:CGFloat {return CGFloat(self)}
    var toInt64: Int64 { return Int64(self)}

    var digits: Int {//this only works in bound of LONG_MAX 2147483647, the maximum value of int
        if(self == 0)
        {
            return 1
        }
        else if(Int(fabs(Double(self))) <= LONG_MAX)
        {
            return Int(log10(fabs(Double(self)))) + 1
        }
    }

    func kSpellOut() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.numberStyle = .spellOut
        return formatter.string(from: NSNumber.init(value: self)) ?? ""
    }

    // MARK: 取区间数
    func getRangeValue(_ range: Range<Int>) -> Int {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        } else{
            return self
        }
    }

}


extension Int64 {

    func kFormatTime() -> String {
        let time: Int64 = self / 1000
        let day = time / 3600 / 24
        let hour = time % (3600 * 24) / 3600
        let minute = (time % 3600) / 60
        let seconds = time % 60
        if day == 0{
            return String(format: "%.2d时%.2d分%.2d秒", hour, minute, seconds)
        }else{
            return String(format: "%2d天%.2d时%.2d分%.2d秒", day, hour, minute, seconds)
        }
    }

    // MARK: 取区间数
    func getRangeValue(_ range: Range<Int64>) -> Int64 {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        } else{
            return self
        }
    }
}
