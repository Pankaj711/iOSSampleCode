//
//  Date+Extension.swift
//  CarFit
//
//  Created by Kamaljeet Punia on 29/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// MARK: - DATE FORMATS ENUM
enum DateFormat: String {
    case appDate = "dd MMM, yyyy"
    case monthYear = "MMM yyyy"
    case month = "M"
    case weekDay = "E"
    case day = "d"
    case dateWithTime = "yyyy-MM-dd'T'HH:mm:ss"
    case year = "yyyy"
}

extension Date {
    
    // MARK: - GET CURRENT CALENDER
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
    }
    
    // MARK: - CONVERT STRING TO DATE WITH DATE FORMAT
    func dateFromString(dateString: String, format: DateFormat) -> Date? {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: dateString)
    }
    
    // MARK: - CONVERT DATE TO STRING WITH DATE FORMAT
    func stringFromDate(format: DateFormat) -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: self as Date)
        if let date = dateFormatter.date(from: dateString){
            return dateFormatter.string(from: date)
        }
        return "N/A"
    }
    
    // MARK: - GET TIME FROM GIVEN DATE
    func getTimeFromDate() -> String {
        let hour = String(format: "%02d", calendar.component(.hour, from: self))
        let minutes = String(format: "%02d", calendar.component(.minute, from: self))
        return "\(hour):\(minutes)"
    }
    
    // MARK: - GET ALL DAYS OF MONTH WITH GIVEN DATE
    func getAllDays(forMonth monthDate: Date) -> [Date] {
        guard let beginingOfMonth = monthDate.beginning(of: .month) else {return [Date()]}
        let totalDays = (calendar.range(of: .day, in: .month, for: beginingOfMonth)!).count
        var daysArray = [beginingOfMonth]
        for days in  1...totalDays-1 {
            daysArray.append(beginingOfMonth.adding(.day, value: days))
        }
        return daysArray
    }
    
    // MARK: - GET BEGINNING OF CALENDAR COMPONENT
    func beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return calendar.startOfDay(for: self)
        }
        var components: Set<Calendar.Component> {
            switch component {
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]
                
            case .minute:
                return [.year, .month, .day, .hour, .minute]
                
            case .hour:
                return [.year, .month, .day, .hour]
                
            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]
                
            case .month:
                return [.year, .month]
                
            case .year:
                return [.year]
                
            default:
                return []
            }
        }
        guard !components.isEmpty else { return nil }
        return calendar.date(from: calendar.dateComponents(components, from: self))
    }

    // MARK: - ADDING ANY COMPONENT OT DATE
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }
    
    // MARK: - CHECK IF DATE IS IN SAME DAY
    func isSameDay(firstDate:Date,secondDate:Date) -> Bool {
        return calendar.isDate(firstDate, inSameDayAs:secondDate)
    }
    
    // MARK: - CHECK IF DATE IS IN CURRENT MONTH
    func isDateInCurrentMonth() -> Bool{
        return Date().stringFromDate(format: .month) == self.stringFromDate(format: .month)
    }
    
    // MARK: - GET INDEX OF DATE FROM MONTH ARRAY
    func getDateIndex() -> Int{
        return (calendar.component(.day, from: self) - 1)
    }
    
    // MARK: - CHECK IF DATE IS IN CURRENT YEAR
    func isDateInCurrentYear() -> Bool{
        return Date().stringFromDate(format: .year) == self.stringFromDate(format: .year)
    }
}
