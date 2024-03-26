//
//  RecurrenceFrequency.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

public enum RecurrenceFrequency: Equatable, Codable {
    case yearly
    case monthly
    case weekly
    case daily
    case hourly
    case minutely
    case secondly

    internal func toString() -> String {
        switch self {
        case .secondly: "SECONDLY"
        case .minutely: "MINUTELY"
        case .hourly: "HOURLY"
        case .daily: "DAILY"
        case .weekly: "WEEKLY"
        case .monthly: "MONTHLY"
        case .yearly: "YEARLY"
        }
    }

    internal static func frequency(from string: String) -> RecurrenceFrequency? {
        switch string {
        case "SECONDLY": .secondly
        case "MINUTELY": .minutely
        case "HOURLY": .hourly
        case "DAILY": .daily
        case "WEEKLY": .weekly
        case "MONTHLY": .monthly
        case "YEARLY": .yearly
        default: nil
        }
    }
}
