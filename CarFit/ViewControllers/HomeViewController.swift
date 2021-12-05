//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    // MARK: - IBOUTLET
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var calendarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarButtonContainerView: UIView!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var noTaskLabel: UILabel!
    
    // MARK: - VARIABLES
    let cellID = "HomeTableViewCell"
    let viewModel = CleanerListViewModel()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handlePullToRefresh),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    // MARK: - CLASS LIFE CYCLE
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getData()
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
        }
    }

    //MARK:- SETUP UI
    private func setupUI() {
        self.navBar.topItem?.title = AppConstants.title.kToday
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        self.workOrderTableView.refreshControl = self.refreshControl
        self.workOrderTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        self.changeCalenderViewState(isShow: false, animated: false)
    }
    
    // MARK: - HANDLE TABLE PULL TO REFRESH
    @objc private func handlePullToRefresh() {
        self.viewModel.filterDataWithSelectedDate(completion: { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.workOrderTableView.reloadData()
        })
    }
    
    // MARK: - TAP GESTURE HANDELING TO HIDE THE CALENDER VIEW
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if self.viewModel.isShowCalender {
            self.changeCalenderViewState(isShow: false)
        }
        sender.cancelsTouchesInView = false
    }
    
    //MARK:- SHOW HIDE CALENDER VIEW
    private func changeCalenderViewState(isShow:Bool, animated: Bool = true) {
        self.viewModel.isShowCalender = isShow
        let time = animated ? 0.5 : 0.0
        UIView.animate(withDuration: time) {
            if isShow {
                self.calendarContainerView.alpha = 1
                self.calendarTopConstraint.constant = 0
                self.calendarButtonContainerView.isHidden = true
            } else {
                self.calendarContainerView.alpha = 0
                self.calendarTopConstraint.constant = -112
                self.calendarButtonContainerView.isHidden = false
            }
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
            self.changeCalenderViewState(isShow: !self.viewModel.isShowCalender)
    }
    
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getSelectedDate(_ date: Date) {
        self.viewModel.selectedDate = date
        self.workOrderTableView.reloadData()
        if date.isSameDay(firstDate: date, secondDate: Date()) {
            self.navBar.topItem?.title = AppConstants.title.kToday
        }else {
            self.navBar.topItem?.title = date.stringFromDate(format: .appDate)
        }
        
    }
    
}

//MARK:- SCROLL VIEW DELEGATE
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.viewModel.isShowCalender {
            self.changeCalenderViewState(isShow: false)
        }
    }
}

// MARK: - GET DATA
extension HomeViewController {
    ///GET CLEANER DATA FROM VIEW MODEL
    func getData() {
        self.viewModel.fetchData { [weak self] (errorMessage) in
            self?.refreshControl.endRefreshing()
            if let message = errorMessage {
                let action = UIAlertAction(title: AppConstants.alert.kOK, style: .default) { (action) in
                    //Handle ok button action
                }
                self?.displayAlert(with: AppConstants.alert.kError, message: message, actions: [action])
            }else {
                self?.workOrderTableView.reloadData()
            }
        }
    }
}
