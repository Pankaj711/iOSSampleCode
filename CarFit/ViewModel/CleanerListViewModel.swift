//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Kamaljeet Punia on 29/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class CleanerListViewModel: NSObject {
    
    // MARK: - VARIABLES
    var cleanerAllData: [CleanerData]
    var cleanerFilteredData: [CleanerData]
    var selectedDate: Date {
        didSet {
            self.filterDataWithSelectedDate(completion: nil)
        }
    }
    var isShowCalender: Bool
    
    // MARK: - CLASS LIFE CYCLE
    override init() {
        self.cleanerAllData = []
        self.cleanerFilteredData = []
        self.selectedDate = Date()
        self.isShowCalender = false
        super.init()
    }
    
    // MARK: - DATA HANDLER FUNCTIONS
    func fetchData(completion: (_ error: String?) -> ()) {
        let result = Parser.shared.readDataFromFile(name: "carfit", forModel: CleanerListData.self)
        switch result {
        case .success(let cleanerData):
            self.cleanerAllData = cleanerData.data ?? []
            self.filterDataWithSelectedDate(completion: nil)
            completion(nil)
        case .failure(let error):
            completion(error.message)
        }
    }
    
    ///Filter data from array with selected date
    func filterDataWithSelectedDate(completion: (() -> ())?) {
        let resultList = cleanerAllData.filter{ Date().isSameDay(firstDate: Date().dateFromString(dateString: $0.startTimeUtc!, format: .dateWithTime)!, secondDate: self.selectedDate)  }
        self.cleanerFilteredData = resultList
        completion?()
    }
}
