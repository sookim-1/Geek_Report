//
//  Int+Extension.swift
//  GeekReport
//
//  Created by sookim on 5/6/24.
//

import Foundation

extension Int {
    
    var formatThousandString: String {
        if self >= 1000 {
            let thousandValue = Double(self) / 1000.0
            let intThousandValue = Int(thousandValue)
            
            return "\(intThousandValue)K"
        } else {
            return "\(self)"
        }
    }
    
}
