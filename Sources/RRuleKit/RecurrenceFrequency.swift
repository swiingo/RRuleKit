//
//  RecurrenceFrequency.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

public enum RecurrenceFrequency: Equatable {
    case byYear
    case byMonth
    case byWeek
    case byDay
    case byHour
    case byMinute
    case bySecond

    internal func toString() -> String {
        switch self {
        case .bySecond: "BYSECOND"
        case .byMinute: "BYMINUTE"
        case .byHour: "BYHOUR"
        case .byDay: "BYDAY"
        case .byWeek: "BYWEEK"
        case .byMonth: "BYMONTH"
        case .byYear: "BYYEAR"
        }
    }

    internal static func frequency(from string: String) -> RecurrenceFrequency? {
        switch string {
        case "BYSECOND": .bySecond
        case "BYMINUTE": .byMinute
        case "BYHOUR": .byHour
        case "BYDAY": .byDay
        case "BYWEEK": .byWeek
        case "BYMONTH": .byMonth
        case "BYYEAR": .byYear
        default: nil
        }
    }
}
