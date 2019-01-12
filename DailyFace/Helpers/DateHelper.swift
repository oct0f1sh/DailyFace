//
//  DateHelper.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/12/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation

class DateHelper {
    static func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"
        
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        } else {
            return "uh oh"
        }
    }
}
