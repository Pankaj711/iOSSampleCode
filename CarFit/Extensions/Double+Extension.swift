//
//  Double+Extension.swift
//  CarFit
//
//  Created by Kamaljeet Punia on 29/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

extension Double {
    // MARK: - ROUND THE DOUBLE VALUE WITH PLACES
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
