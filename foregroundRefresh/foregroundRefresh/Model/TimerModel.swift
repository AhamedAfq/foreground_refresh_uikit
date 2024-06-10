//
//  TimerModel.swift
//  foregroundRefresh
//
//  Created by Ashfak Ahamed Alauddeen on 09/06/24.
//

import Foundation

struct TimerModel: Codable {
    var name: String
    var data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    var year: Int
    var price: Double
    var isTimerRunning, status, color: String

    enum CodingKeys: String, CodingKey {
        case year, price
        case isTimerRunning = "CPU model"
        case status = "Hard disk size"
        case color
    }
}
