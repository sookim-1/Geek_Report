//
//  GlobalDateFormmater.swift
//  GeekReport
//
//  Created by sookim on 4/28/24.
//

import Foundation

class GlobalDateFormmater: DateFormatter {
    
    static let shared = GlobalDateFormmater()
    
    func getCurrentYear() -> Int {
        self.dateFormat = "yyyy"
        let currentYear = self.string(from: Date())
        
        return Int(currentYear) ?? 0
    }
    
}
