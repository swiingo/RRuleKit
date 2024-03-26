//
//  RecurrenceRule.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import EventKit

public struct RecurrenceRule: Equatable {
    /// The calendar of recurrence rule.
    public var calendar = Calendar.current
    
    /// The frequency of the recurrence rule.
    public var frequency: RecurrenceFrequency
    
    /// Specifies how often the recurrence rule repeats over the component of time indicated by its frequency. For example, a recurrence rule with a frequency type of RecurrenceFrequency.weekly and an interval of 2 repeats every two weeks.
    ///
    /// The default value of this property is 1.
    public var interval = 1
    
    /// Indicates which day of the week the recurrence rule treats as the first day of the week.
    ///
    /// The default value of this property is EKWeekday.monday.
    public var firstDayOfWeek: EKWeekday = .monday
    
    /// The start date of recurrence rule.
    ///
    /// The default value of this property is current date.
    public var startDate = Date()
    
    /// Indicates when the recurrence rule ends. This can be represented by an end date or a number of occurrences.
    public var recurrenceEnd: EKRecurrenceEnd?
    
    /// An array of ordinal integers that filters which recurrences to include in the recurrence rule’s frequency. Values can be from 1 to 366 and from -1 to -366.
    ///
    /// For example, if a bysetpos of -1 is combined with a RecurrenceFrequency.monthly frequency, and a byweekday of (EKWeekday.monday, EKWeekday.tuesday, EKWeekday.wednesday, EKWeekday.thursday, EKWeekday.friday), will result in the last work day of every month.
    ///
    /// Negative values indicate counting backwards from the end of the recurrence rule’s frequency.
    public var bysetpos = [Int]()
    
    /// The days of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 366 and from -1 to -366.
    ///
    /// Negative values indicate counting backwards from the end of the year.
    public var byyearday = [Int]()
    
    /// The months of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 12.
    public var bymonth = [Int]()
    
    /// The weeks of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 53 and from -1 to -53. According to ISO8601, the first week of the year is that containing at least four days of the new year.
    ///
    /// Negative values indicate counting backwards from the end of the year.
    public var byweekno = [Int]()
    
    /// The days of the month associated with the recurrence rule, as an array of integers. Values can be from 1 to 31 and from -1 to -31.
    ///
    /// Negative values indicate counting backwards from the end of the month.
    public var bymonthday = [Int]()
    
    /// The days of the week associated with the recurrence rule, as an array of EKWeekday objects.
    public var byweekday = [EKWeekday]()
    
    /// The hours of the day associated with the recurrence rule, as an array of integers.
    public var byhour = [Int]()
    
    /// The minutes of the hour associated with the recurrence rule, as an array of integers.
    public var byminute = [Int]()
    
    /// The seconds of the minute associated with the recurrence rule, as an array of integers.
    public var bysecond = [Int]()
    
    /// The inclusive dates of the recurrence rule.
    public var rdate: InclusionDate?
    
    /// The exclusion dates of the recurrence rule. The dates of this property will not be generated, even if some inclusive rdate matches the recurrence rule.
    public var exdate: ExclusionDate?
    
    public init(frequency: RecurrenceFrequency) {
        self.frequency = frequency
    }
    
    public init?(rruleString: String) {
        if let recurrenceRule = RRule.ruleFromString(rruleString) {
            self = recurrenceRule
        } else {
            return nil
        }
    }
    
    public func toRRuleString() -> String {
        RRule.stringFromRule(self)
    }
}

extension EKWeekday: Codable {}

extension RecurrenceRule: Codable {
    internal enum Keys: CodingKey {
        case calendar
        case frequency
        case interval
        case firstDayOfWeek
        case startDate
        case endDate
        case occurrenceCount
        case bysetpos
        case byyearday
        case bymonth
        case byweekno
        case bymonthday
        case byweekday
        case byhour
        case byminute
        case rdate
        case exdate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        calendar = try container.decode(Calendar.self, forKey: .calendar)
        frequency = try container.decode(RecurrenceFrequency.self, forKey: .frequency)
        interval = try container.decode(Int.self, forKey: .interval)
        firstDayOfWeek = try container.decode(EKWeekday.self, forKey: .firstDayOfWeek)
        startDate = try container.decode(Date.self, forKey: .startDate)
        recurrenceEnd = if let endDate = try? container.decodeIfPresent(Date.self, forKey: .endDate) {
            .init(end: endDate)
        } else if let occurrenceCount = try? container.decodeIfPresent(Int.self, forKey: .occurrenceCount) {
            .init(occurrenceCount: occurrenceCount)
        } else {
            nil
        }
        bysetpos = try container.decode([Int].self, forKey: .bysetpos)
        byyearday = try container.decode([Int].self, forKey: .byyearday)
        bymonth = try container.decode([Int].self, forKey: .bymonth)
        byweekno = try container.decode([Int].self, forKey: .byweekno)
        bymonthday = try container.decode([Int].self, forKey: .bymonthday)
        byweekday = try container.decode([EKWeekday].self, forKey: .byweekday)
        byhour = try container.decode([Int].self, forKey: .byhour)
        byminute = try container.decode([Int].self, forKey: .byminute)
        rdate = try container.decode(InclusionDate.self, forKey: .rdate)
        exdate = try container.decode(ExclusionDate.self, forKey: .exdate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(calendar, forKey: .calendar)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(interval, forKey: .interval)
        try container.encode(firstDayOfWeek, forKey: .firstDayOfWeek)
        try container.encode(startDate, forKey: .startDate)
        if let endDate = recurrenceEnd?.endDate {
            try container.encode(endDate, forKey: .endDate)
        } else if let occurrenceCount = recurrenceEnd?.occurrenceCount {
            try container.encode(occurrenceCount, forKey: .occurrenceCount)
        }
        try container.encode(bysetpos, forKey: .bysetpos)
        try container.encode(byyearday, forKey: .byyearday)
        try container.encode(bymonth, forKey: .bymonth)
        try container.encode(byweekno, forKey: .byweekno)
        try container.encode(bymonthday, forKey: .bymonthday)
        try container.encode(byweekday, forKey: .byweekday)
        try container.encode(byhour, forKey: .byhour)
        try container.encode(byminute, forKey: .byminute)
        try container.encode(rdate, forKey: .rdate)
        try container.encode(exdate, forKey: .exdate)
    }
}
