//
//  Date+extension.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import Foundation

extension Date {
    func str() -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // format
        dateFormatter.dateFormat = "YYYY-MM-dd"
        // Convert Date to String
        let str = dateFormatter.string(from: self)
        return str
    }
}
