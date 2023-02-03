//
//  Date.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit

extension Date {
    var hour: Int {
        let calendar = NSCalendar.current
        return calendar.component(.hour, from: self)
    }
    var minute: Int {
        let calendar = NSCalendar.current
        return calendar.component(.minute, from: self)
    }
    var second: Int {
        let calendar = NSCalendar.current
        return calendar.component(.second, from: self)
    }
    var day: Int {
        let calendar = NSCalendar.current
        return calendar.component(.day, from: self)
    }

    var month: Int {
        let calendar = NSCalendar.current
        return calendar.component(.month, from: self)
    }

    var year: Int {
        let calendar = NSCalendar.current
        return calendar.component(.year, from: self)
    }

    func compareDate(_ date: Date) -> Bool {
        return self.day == date.day && self.month == date.month && self.year == date.year
    }

    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }

    func formatTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
        return dateFormatter.string(from: self)
    }

    func dateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return (self.dayOfTheWeek() ?? "") + ", " + dateFormatter.string(from: self)
    }

    func dayOfTheWeek() -> String? {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]

        let calendar = Calendar.current
        let components = calendar.component(.weekday, from: self)
        return weekdays[components - 1]
    }
    

}
