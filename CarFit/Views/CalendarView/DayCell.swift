//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    // MARK: - CLASS LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
    
    // MARK: - SETUP CELL
    func setupCell(date:Date, selectedDate:Date) {
        self.day.text = date.stringFromDate(format: .day)
        self.weekday.text = date.stringFromDate(format: .weekDay)
        if Date().isSameDay(firstDate: date, secondDate: selectedDate){
            self.dayView.backgroundColor = UIColor.gray
        } else {
            self.dayView.backgroundColor = .clear
        }
    }
}
