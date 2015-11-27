//
//  Scheduler.swift
//  SurveyManager
//
//  Created by Bruce Collie on 12/08/2014.
//  Copyright (c) 2014 University of Cambridge Computer Laboratory. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

public class Scheduler {
    
    public class var sharedInstance : Scheduler {
        struct Static {
            static let instance : Scheduler = Scheduler()
        }
        return Static.instance
    }
    
    init() {
        
    }
    
    public class func schedulerFromJSONString(json: String) -> Scheduler? {
        var dict = decodeJSON(json)!
        return schedulerFromJSONValue(dict)
    }
    
    public class func schedulerFromJSONValue(dict: JSONValue) -> Scheduler {
        var ret = Scheduler()
        
        var ends : [NSDate] = []
        
        if let triggers = dict["schedule"].array {
            for trigger : JSONValue in triggers {
                if let identifier = trigger["unique_identifier"].string,
                        hour = trigger["hour_of_day"].integer,
                        minute = trigger["minute_in_hour"].integer {
                            
                    var notification = UILocalNotification()
                            
                    notification.repeatInterval = NSCalendarUnit.CalendarUnitDay
                    notification.fireDate = NSDate.nextDateFromMinuteInHour(hour, minute: minute)
                    notification.timeZone = NSTimeZone.defaultTimeZone()
                    notification.alertAction = "take survey"
                    notification.alertBody = "You have an Easy M survey waiting for you!"
                    notification.applicationIconBadgeNumber = 1
                    notification.soundName = UILocalNotificationDefaultSoundName
                    
                    var endDate = notification.fireDate! + 15.minutes
                    var userInfo = [
                        "identifier" : identifier,
                        "endBy" : endDate
                    ]
                    notification.userInfo = userInfo
                    
                    println("Scheduled notification for: \(notification.fireDate!)")

                    ends.append(endDate)
                            
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                }
            }
        }
        
        ends.sort { $0.compare($1) == NSComparisonResult.OrderedAscending }
        NSUserDefaults.standardUserDefaults().setObject(ends, forKey: "QuickEndDates")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        return ret
    }
    
    public func cancelAllNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
}