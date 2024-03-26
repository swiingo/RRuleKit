//
//  ExclusionDate.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public struct ExclusionDate: Equatable, Codable {
    /// All exclusion dates.
    public fileprivate(set) var dates = [Date]()
    /// The component of ExclusionDate, used to decide which exdate will be excluded.
    public fileprivate(set) var component: Calendar.Component!

    public init(dates: [Date], granularity component: Calendar.Component) {
        self.dates = dates
        self.component = component
    }

    public init?(exdateString string: String, granularity component: Calendar.Component) {
        let string = string.trimmingCharacters(in: .whitespaces)
        guard let range = string.range(of: "EXDATE:"), range.lowerBound == string.startIndex else {
            return nil
        }
        let exdateString = String(string.suffix(from: range.upperBound))
        let exdates = exdateString.components(separatedBy: ",").compactMap { (dateString) -> String? in
            if dateString.isEmpty {
                return nil
            }
            return dateString
        }

        self.dates = exdates.compactMap({ (dateString) -> Date? in
            if let date = RRule.dateFormatter.date(from: dateString) {
                return date
            } else if let date = RRule.realDate(dateString) {
                return date
            }
            return nil
        })
        self.component = component
    }

    public func toExDateString() -> String? {
        var exdateString = "EXDATE:"
        let dateStrings = dates.map { (date) -> String in
            return RRule.dateFormatter.string(from: date)
        }
        if dateStrings.count > 0 {
            exdateString += dateStrings.joined(separator: ",")
        } else {
            return nil
        }

        if String(exdateString.suffix(from: exdateString.index(exdateString.endIndex, offsetBy: -1))) == "," {
            exdateString.remove(at: exdateString.index(exdateString.endIndex, offsetBy: -1))
        }

        return exdateString
    }
}

extension Calendar.Component: RawRepresentable {
    public var rawValue: Int {
        switch self {
        case .calendar: 0
        case .day: 1
        case .era: 2
        case .hour: 3
        case .minute: 4
        case .month: 5
        case .nanosecond: 6
        case .quarter: 7
        case .second: 8
        case .timeZone: 9
        case .weekday: 10
        case .weekdayOrdinal: 11
        case .weekOfMonth: 12
        case .weekOfYear: 13
        case .year: 14
        case .yearForWeekOfYear: 15
        case .isLeapMonth: 16
        @unknown default: fatalError()
        }
    }

    public init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .calendar
        case 1: self = .day
        case 2: self = .era
        case 3: self = .hour
        case 4: self = .minute
        case 5: self = .month
        case 6: self = .nanosecond
        case 7: self = .quarter
        case 8: self = .second
        case 9: self = .timeZone
        case 10: self = .weekday
        case 11: self = .weekdayOrdinal
        case 12: self = .weekOfMonth
        case 13: self = .weekOfYear
        case 14: self = .year
        case 15: self = .yearForWeekOfYear
        default: return nil
        }
    }
}

extension Calendar.Component: Codable {
    enum DecodingError: Error {
        case unknownRawValue
    }

    /// Throwable initialiser that throws when an unknown `RawValue` is passed to it
    /// Necessary for `init(from decoder:)` to be able to delegate to a non-failable init
    init(value: Int) throws {
        guard let component = Calendar.Component(rawValue: value) else {
            throw DecodingError.unknownRawValue
        }
        self = component
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        
        try self.init(value: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(self)
    }
}
