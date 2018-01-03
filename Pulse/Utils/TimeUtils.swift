//
//  TimeUtils.swift
//  Pulse
//
//  Created by Luke Klinker on 1/3/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation

extension Int64 {
    func isToday() -> Bool {
        return NSCalendar.current.isDateInToday(Date(milliseconds: self))
    }
    
    func isYesterday() -> Bool {
        return NSCalendar.current.isDateInYesterday(Date(milliseconds: self))
    }
    
    func isLastWeek() -> Bool {
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        return NSCalendar.current.compare(lastWeekDate, to: Date(milliseconds: self), toGranularity: .minute) == ComparisonResult.orderedAscending
    }
    
    func isLastMonth() -> Bool {
        let lastWeekDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        return NSCalendar.current.compare(lastWeekDate, to: Date(milliseconds: self), toGranularity: .minute) == ComparisonResult.orderedAscending
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
