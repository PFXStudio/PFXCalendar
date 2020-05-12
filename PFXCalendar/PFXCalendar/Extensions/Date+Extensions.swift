//
//  Date+Extensions.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return sunday
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var yearKr: String {
        get {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "KST")!
            return "\(calendar.component(.year, from: self))"
        }
    }

    var monthKr: String {
        get {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "KST")!
            return "\(calendar.component(.month, from: self))"
        }
    }

    var dayKr: String {
        get {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "KST")!
            return "\(calendar.component(.day, from: self))"
        }
    }

    var hour: String {
        get {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "KST")!
            return "\(calendar.component(.hour, from: self))"
        }
    }

    var weekdaySymbol: String {
        get {
            let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
            return weekDays[self.weekdayIndex]
        }
    }
    
    var weekdayIndex: Int {
        get {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "KST")!
            return calendar.component(.weekday, from: self) - 1
        }
    }
    
    var maxWeekdayIndex: Int {
        get {
            return 6
        }
    }
}
