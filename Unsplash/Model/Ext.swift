//
//  Ext.swift
//  Unsplash
//
//  Created by Александр Шерий on 04.09.2022.
//

import Foundation

extension Date {
    var dateText: String {
        let formatter = DateFormatter()
        var format = "d MMM"
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = Calendar.current.component(.year, from: self)
        
        if year != currentYear {
            format += ", YYYY"
        }
        
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
