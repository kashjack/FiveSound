//
//  Date+Extension.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2020/5/13.
//  Copyright © 2020 worldunionViolet. All rights reserved.
//

import UIKit

extension Date{

    static func nowTime() -> Int32 {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int32(timeInterval)
        return timeStamp
    }

    static func nowMilliTime() -> Int32 {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = Int32(round(timeInterval*1000))
        return millisecond
    }

    func daysInBetweenDate(date: Date) -> Double
    {
        var diff = timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/86400)
        return diff
    }

    func hoursInBetweenDate(date: Date) -> Double
    {
        var diff = timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/3600)
        return diff
    }

    func minutesInBetweenDate(date: Date) -> Double
    {
        var diff = timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/60)
        return diff
    }

    func secondsInBetweenDate(date: Date) -> Double
    {
        var diff = timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff)
        return diff
    }

}
