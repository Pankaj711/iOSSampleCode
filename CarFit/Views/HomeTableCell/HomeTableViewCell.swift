//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    // MARK: - IBOUTLETS
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    // MARK: - CLASS LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    // MARK: - SETUP CELL WITH MODEL
    func setupCell(currentCleanerData : CleanerData, lastCleanerData : CleanerData?){
        customer.text = "\(currentCleanerData.houseOwnerFirstName ?? "") \(currentCleanerData.houseOwnerLastName ?? "")"
        status.text = currentCleanerData.visitState?.rawValue ?? ""
        if let startTime = currentCleanerData.startTimeUtc {
            let arrivalTimeDate =  Date().dateFromString(dateString: startTime, format: .appDate) ?? Date()
            let expectedTime = "/ \(currentCleanerData.expectedTime ?? "")"
            arrivalTime.text = "\(arrivalTimeDate.getTimeFromDate()) \(expectedTime)"
        }
        if let taskArray = currentCleanerData.tasks {
            let washingTitles = taskArray.map{($0.title ?? "")}.joined(separator: ", ")
            tasks.text = washingTitles
            let washingTime = taskArray.map{($0.timesInMinutes ?? 0)}.reduce(0, +)
            timeRequired.text = "\(washingTime) min"
        }
        destination.text = "\(currentCleanerData.houseOwnerAddress ?? "") \(currentCleanerData.houseOwnerZip ?? "") \(currentCleanerData.houseOwnerCity ?? "")"
        setupNextDistanceValue(cleanerData : currentCleanerData,previousCleanerData : lastCleanerData)
        self.setupStateViewColor(cleanerData: currentCleanerData)
    }
    
    // MARK: - PRIVATE FUNCIONS
    private func setupNextDistanceValue(cleanerData : CleanerData,previousCleanerData : CleanerData?){
        var distanceValue = 0.0
        if previousCleanerData != nil {
            let coordinate0 = CLLocation(latitude: cleanerData.houseOwnerLatitude ?? 0.0, longitude: cleanerData.houseOwnerLongitude ?? 0.0)
            let coordinate1 = CLLocation(latitude: previousCleanerData?.houseOwnerLatitude ?? 0.0, longitude: previousCleanerData?.houseOwnerLongitude ?? 0.0)
            let distanceInKm = coordinate0.distance(from: coordinate1) / 1000.0
            distanceValue = distanceInKm.rounded(toPlaces: 2)
        }
        distance.text = "\(distanceValue) Km"
    }
    
    ///Setup state view color according to cleaner state type
    private func setupStateViewColor(cleanerData : CleanerData){
        guard let type = cleanerData.visitState else { return }
        self.statusView.backgroundColor = type.getColor()
    }
}
