//
//  NSDate.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 22/08/2016.
//  Copyright © 2016 Bathilde ROCCHIA. All rights reserved.
//

import Foundation

public extension Date {
  
  var year: Int? { get { return Calendar.current.dateComponents([.year], from: self).year } }
  var month: Int? { get { return Calendar.current.dateComponents([.month], from: self).month } }
  var day: Int? { get { return Calendar.current.dateComponents([.day], from: self).day } }
  var hour: Int? { get { return Calendar.current.dateComponents([.hour], from: self).hour } }
  var minute: Int? { get { return Calendar.current.dateComponents([.minute], from: self).minute } }
  var second: Int? { get { return Calendar.current.dateComponents([.second], from: self).second } }
  
  var weekDay: Int? { get { return Calendar.current.dateComponents([.weekday], from: self).weekday } }
  
  public func addDays(_ daysToAdd: Int) -> Date {
    let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
    let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
    return dateWithDaysAdded
  }
  
  public func addHours(_ hoursToAdd: Int) -> Date {
    let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
    let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
    return dateWithHoursAdded
  }
  
  static public func <(lhs: inout Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
  }
  static public func >(lhs: inout Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedDescending
  }
  static public func ==(lhs: inout Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedSame
  }
}
