//
//  CleanerListModel.swift
//  CarFit
//
//  Created by Kamaljeet Punia on 29/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CLEANER LIST DATA MODEL
struct CleanerListData:Decodable {
    let success: Bool?
    let message: String?
    var data: [CleanerData]?
    let code: Int?
}

// MARK: - CLEANER DATA MODEL
struct CleanerData: Decodable {
    let visitId: String?
    let startTimeUtc: String?
    let endTimeUtc: String?
    let houseOwnerFirstName: String?
    let houseOwnerLastName: String?
    let houseOwnerMobilePhone: String?
    let houseOwnerAddress: String?
    let houseOwnerZip: String?
    let houseOwnerCity: String?
    let houseOwnerLatitude: Double?
    let houseOwnerLongitude: Double?
    let visitState: VisitState?
    let expectedTime: String?
    let tasks: [Cleanertask]?
}

// MARK: - CLEANER TASK
struct Cleanertask: Decodable {
    let taskId: String?
    let title: String?
    let timesInMinutes: Int?
    let price: Double?
}

// MARK: - VISIT STATE ENUM & GET COLOR ACCORDING TO STATE
enum VisitState: String, Decodable {
    case done = "Done"
    case inProgress = "InProgress"
    case todo = "ToDo"

    func getColor() -> UIColor {
        switch self {
        case .done:
            return UIColor.doneOption
        case .inProgress:
            return UIColor.inProgressOption
        case .todo:
            return UIColor.todoOption
        }
    }
}
