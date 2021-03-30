//
//  TimeInterval+Extension.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/11/12.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit

extension TimeInterval {
    
    func kConvertToDateStr(_ dateFormat: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(identifier: "UTC+8")
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        var date = Date.init(timeIntervalSince1970: self)
        if self > 10000000000 {
            date = Date.init(timeIntervalSince1970: self / 1000)
        }
        if self == 0 {
            return ""
        }
        return formatter.string(from: date)
    }

}
