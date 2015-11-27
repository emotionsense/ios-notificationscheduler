import Foundation

extension NSTimeInterval {
    
    var asSeconds : Int { return Int(self) }
    
    var asMinutes : Int { return self.asSeconds / 60 }
    
    var asHours : Int { return self.asMinutes / 60 }
    
    var asDays : Int { return self.asHours / 24 }
    
    var asWeeks : Int { return self.asDays / 7 }
    
    var asMonths : Int { return self.asDays / 30 }
    
    var asYears : Int { return self.asDays / 365 }
    
}

extension Double {
    
    var seconds : NSTimeInterval { return self }
    
    var minutes : NSTimeInterval { return self * 60.0 }
    
    var hours : NSTimeInterval { return self.minutes * 60.0 }
    
    var days : NSTimeInterval { return self.hours * 24.0 }
    
    var weeks : NSTimeInterval { return self.days * 7.0 }
    
    var months : NSTimeInterval { return self.days * 30.0 }
    
    var years : NSTimeInterval { return self.days * 365.0 }
    
}

extension Int {
    
    var seconds : NSTimeInterval { return Double(self) }
    
    var minutes : NSTimeInterval { return Double(self * 60) }
    
    var hours : NSTimeInterval { return self.minutes * 60.0 }
    
    var days : NSTimeInterval { return self.hours * 24.0 }
    
    var weeks : NSTimeInterval { return self.days * 7.0 }
    
    var months : NSTimeInterval { return self.days * 30.0 }
    
    var years : NSTimeInterval { return self.days * 365.0 }
    
}

func +(lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return NSDate(timeInterval: rhs, sinceDate: lhs)
}

func +(lhs: NSTimeInterval, rhs: NSDate) -> NSDate {
    return NSDate(timeInterval: lhs, sinceDate: rhs)
}

func -(lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return NSDate(timeInterval: -rhs, sinceDate: lhs)
}

func -(lhs: NSTimeInterval, rhs: NSDate) -> NSDate {
    return NSDate(timeInterval: -lhs, sinceDate: rhs)
}

extension NSDate {
    
    public func before(other: NSDate) -> Bool {
        return self.timeIntervalSince1970 < other.timeIntervalSince1970
    }
    
    public func after(other: NSDate) -> Bool {
        return self.timeIntervalSince1970 > other.timeIntervalSince1970
    }
    
}

extension NSDate {
    
    public func readableIntervalUntilEndDate(end: NSDate) -> String {
        let interval = end.timeIntervalSinceNow
        if interval < 30.seconds {
            return "Very soon"
        } else if interval < 60.minutes {
            switch(interval.asMinutes) {
            case 1:
                return "\(interval.asMinutes) minute"
            default:
                return "\(interval.asMinutes) minutes"
            }
        } else if interval < 1.days {
            switch(interval.asHours) {
            case 1:
                return "\(interval.asHours) hour"
            default:
                return "\(interval.asHours) hours"
            }
        } else if interval < 1.weeks {
            switch(interval.asDays) {
            case 1:
                return "\(interval.asDays) day"
            default:
                return "\(interval.asDays) days"
            }
        } else if interval < 1.months {
            switch(interval.asWeeks) {
            case 1:
                switch(interval.asDays - interval.asWeeks * 7) {
                case 1:
                    return "\(interval.asWeeks) week, \(interval.asDays - interval.asWeeks * 7) day"
                default:
                    return "\(interval.asWeeks) week, \(interval.asDays - interval.asWeeks * 7) days"
                }
            default:
                switch(interval.asDays - interval.asWeeks * 7) {
                case 1:
                    return "\(interval.asWeeks) weeks, \(interval.asDays - interval.asWeeks * 7) day"
                default:
                    return "\(interval.asWeeks) weeks, \(interval.asDays - interval.asWeeks * 7) days"
                }
            }
        } else if interval < 1.years {
            switch(interval.asMonths) {
            case 1:
                switch(interval.asDays - interval.asMonths * 30) {
                case 1:
                    return "\(interval.asMonths) month, \(interval.asDays - interval.asMonths * 30) day"
                default:
                    return "\(interval.asMonths) month, \(interval.asDays - interval.asMonths * 30) days"
                }
            default:
                switch(interval.asDays - interval.asWeeks * 7) {
                case 1:
                    return "\(interval.asMonths) months, \(interval.asDays - interval.asMonths * 30) day"
                default:
                    return "\(interval.asMonths) months, \(interval.asDays - interval.asMonths * 30) days"
                }
            }
        }
        else {
            return "In A Long Time"
        }
    }
    
}

extension NSDate {
    
    class func nextDateFromMinuteInHour(hour: Int, minute: Int) -> NSDate {
        var now = NSDate()
        var components = NSCalendar.currentCalendar().components(   NSCalendarUnit.CalendarUnitHour |
            NSCalendarUnit.CalendarUnitMinute |
            NSCalendarUnit.CalendarUnitDay |
            NSCalendarUnit.CalendarUnitMonth |
            NSCalendarUnit.CalendarUnitYear, fromDate: now)
        if components.hour >= hour && components.minute >= minute {
            components.day += 1
        }
        components.hour = hour
        components.minute = minute
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
}