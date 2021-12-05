//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

// MARK: - CALENDAR VIEW PROTOCOL
protocol CalendarDelegate: class {
    func getSelectedDate(_ date: Date)
}

class CalendarView: UIView {

    // MARK: - IBOUTLETS
    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    // MARK: - VARIABLES
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?
    private var calenderDates = CalenderDates()
    private var selectedDate = Date() {
        didSet {
            self.daysCollectionView.reloadData()
        }
    }

    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        self.setupUI()
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        if sender == leftBtn{
            self.calenderDates.month = self.calenderDates.month.adding(.month, value: -1)
        }
        if sender == rightBtn {
            self.calenderDates.month = self.calenderDates.month.adding(.month, value: 1)
        }
        monthAndYear.text = self.calenderDates.month.stringFromDate(format: .monthYear)
        self.setupUI()
    }
    
    //MARK: - SETUP UI
    private func setupUI() {
        monthAndYear.text = self.calenderDates.month.stringFromDate(format: .monthYear)
        self.calenderDates.days =  Date().getAllDays(forMonth: self.calenderDates.month)
        if self.calenderDates.days.count == 0 {return}
        self.daysCollectionView.reloadData()
        if self.calenderDates.month.isDateInCurrentYear() && self.calenderDates.month.isDateInCurrentMonth() {
            self.selectedDate = Date()
            self.delegate?.getSelectedDate(self.selectedDate)
            if self.calenderDates.days.count > self.selectedDate.getDateIndex() {
                self.daysCollectionView.scrollToItem(at: IndexPath(item: self.selectedDate.getDateIndex() , section: 0), at: .left, animated: true)
            }
            return
        }
        self.daysCollectionView.scrollToItem(at: IndexPath(item: 0 , section: 0), at: .left, animated: true)
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.calenderDates.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        cell.setupCell(date: self.calenderDates.days[indexPath.row], selectedDate: self.selectedDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDate = self.calenderDates.days[indexPath.row]
        self.delegate?.getSelectedDate(self.selectedDate)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
